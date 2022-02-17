//
//  NetworkClient.swift
//  SwiftProject
//
//  Created by Ifeng科技 on 2020/5/20.
//  Copyright © 2020 Ifeng科技. All rights reserved.
//

import Foundation
import Alamofire

///这个的目的是为了防止多次调用更新token接口
fileprivate var updateTokenGuard = false

//MARK: -
extension NSError {
    func getErrorReason() -> String {
        guard let reason = userInfo[NSLocalizedFailureReasonErrorKey] as? String else  {
            return self.localizedDescription
        }
        return reason
    }
    
    static func error(with tipMsg:String) -> NSError {
        let userInfo = [NSLocalizedFailureReasonErrorKey:tipMsg]
        return NSError(domain: "netclient.error", code: -500, userInfo: userInfo)
    }
}

//MARK: -
extension Error {
    func getNSErrorReason() -> String {
        return (self as NSError).getErrorReason()
    }
}


fileprivate extension HTTPMethod {
    var afnHTTPMethod:Alamofire.HTTPMethod {
        switch self {
        case .GET:
            return Alamofire.HTTPMethod.get
        case .POST:
            return Alamofire.HTTPMethod.post
        }
    }
}



//MARK: -
final class Network2Client: Client {
   
    private(set) var host: String
    
    let session:Session
    
    init(host:String) {
        self.host = host
        self.session = Session(startRequestsImmediately:false)
    }
    
    var token: String? = nil
    
    lazy private var requestModifier:Session.RequestModifier = {
        [weak self] request in
        
        if let token = self?.token,
           token.isEmpty == false {
            request.setValue(token, forHTTPHeaderField: "X-Nft-Front-Token")
        }
    }
}

//MARK:
extension Network2Client {
    struct StatusCode {
        static let success = "2000"
        static let notLogin = "4001"
    }
    
    func send(_ request: Request, completion: @escaping Completion) {
         _send(request, completion: completion)
    }
    
    
    private func _send(_ request: Request, completion: @escaping Completion)  {
        let fullPath = host + request.path
        let encoder = URLEncodedFormParameterEncoder.default
        let headers:HTTPHeaders? = nil
        
        let request = session
            .request(fullPath,
                     method: request.method.afnHTTPMethod,
                     parameters: request.parameters,
                     encoder: encoder,
                     headers: headers,
                     interceptor: nil,
                     requestModifier: self.requestModifier)
        
        request
            .response { dataResponse in
            
            if self.handleCommonError(for: dataResponse, completion: completion) {
                return
            }
            
            self.handleServerResponse(dataResponse, completion: completion)
        }
        
        request.resume()
    }
    
    
    func sendAndGetData(_ request: Request, completion: @escaping Completion) {
        
        _sendAndGetData(request, completion: completion)
    }
    
    
   private func _sendAndGetData(_ request: Request, completion: @escaping Completion) {
        
        
        let fullPath = host + request.path
        let encoder = URLEncodedFormParameterEncoder.default
        let headers:HTTPHeaders? = nil
        
        let request = session
            .request(fullPath,
                     method: request.method.afnHTTPMethod,
                     parameters: request.parameters,
                     encoder: encoder,
                     headers: headers,
                     interceptor: nil,
                     requestModifier: self.requestModifier)
        
        request.response { dataResponse in
            
            if self.handleCommonError(for: dataResponse, completion: completion) {
                return
            }
            
            completion(dataResponse.data,dataResponse.error)
        }
        
        request.resume()
    }
    
    
    func sendUploadData(_ request: UploadDatasRequest, completion: @escaping Completion) {
        guard
            request.datas.count == request.mimeTypes.count,
            request.datas.count == request.names.count
        else {
            completion(nil,NSError.error(with: "上传参数设置错误"))
            return
        }
        let fullPath = host + request.path
        var allMimetypeSuccess = true
        let uploadReq = session.upload(multipartFormData: { multipartFormData in
            for idx in 0..<request.datas.count {
                if let fileType = request.mimeTypes[idx].split(separator: "/").last {
                    let fileName = "\(Date().timeIntervalSince1970)." + fileType
                    multipartFormData.append(request.datas[idx], withName: request.names[idx], fileName: fileName, mimeType: request.mimeTypes[idx])
                } else {
                    allMimetypeSuccess = false
                    break
                }
            }
            
        }, to: fullPath)
        guard allMimetypeSuccess else {
            completion(nil,NSError.error(with: "上传数据mimetype错误"))
            return
        }
        uploadReq.response { dataResponse  in
            if self.handleCommonError(for: dataResponse, completion: completion) {
                return
            }
            self.handleServerResponse(dataResponse, completion: completion)
        }
        uploadReq.resume()
    }
}


//MARK:
private extension Network2Client {
    func handleCommonError(for dataResponse:AFDataResponse<Data?>,completion: @escaping Completion) -> Bool {
        ///提示网络情况相关的错误
        if let error = dataResponse.error as AFError? {
            if case let .sessionTaskFailed(error: e) = error {
                if let nsError = e as NSError? {
                    if nsError.code == URLError.Code.notConnectedToInternet.rawValue ||
                        nsError.code == URLError.Code.networkConnectionLost.rawValue
                    {
                        completion(nil,NSError.error(with: "似乎已断开与互联网的连接"))
                    } else if nsError.code == URLError.Code.timedOut.rawValue {
                        completion(nil,NSError.error(with: "请求超时"))
                    } else {
                        completion(nil,NSError.error(with: error.localizedDescription))
                    }
                    
                }
            } else {
                completion(nil,NSError.error(with: error.errorDescription ?? "未知错误"))
            }
            return true
        }
        //处理 HTTP错误
        if  let statusCode = dataResponse.response?.statusCode {
            if (statusCode >= 200 && statusCode < 300) == false {
                completion(nil,NSError.error(with: "HTTP错误,状态码\(statusCode)"))
                return true
            }
        }
        
        return false
    }
    
    
    func handleServerResponse(_ dataResponse:AFDataResponse<Data?>,completion: @escaping Completion) {
        if dataResponse.data != nil {
            if let respDic = try? JSONSerialization.jsonObject(with: dataResponse.data!, options: JSONSerialization.ReadingOptions.fragmentsAllowed) as? [String:Any] {
                
                if let code = respDic["code"] as? String {
                    if code == StatusCode.success {
                        completion(dataResponse.data,nil)
                    }  else {
                        if code == StatusCode.notLogin {
                            //清空登录信息
                        }
                        
                        if let errmsg = respDic["message"] as? String {
                            completion(nil,NSError.error(with: errmsg))
                        }
                        else {
                            completion(nil,NSError.error(with: "接口错误:\(code)"))
                        }
                    }
                }
                else {
                    completion(nil,NSError.error(with: "不存在code字段"))
                }
                
            } else {
                completion(nil,NSError.error(with: "数据不是JSON格式"))
            }
        }
        else {
            completion(nil,NSError.error(with: "响应数据为空"))
        }
    }
}


