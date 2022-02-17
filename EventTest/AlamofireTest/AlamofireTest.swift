//
//  AlamofireTest.swift
//  EventTest
//
//  Created by apple on 2020/9/27.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import Alamofire
//MARK:-

struct AlamofireTest {
    func sendTest() {
        
      //  let request:Request = LoginRequest(userName: "15847209769", password: "a11111111"
        
        let request:Request = UserInfoRequest()
        ClientFactory.httpSharedClient.send(
            
            request)
        { data, error in
                if error != nil {
                    debugPrint("error:\(error!.getNSErrorReason())")
                    return
                }
                
                if data != nil {
                    let resultStr = String.init(data: data!, encoding: .utf8) ?? "数据不能转为String"
                    debugPrint(resultStr)
                }
            }
    }
    
    
    func sendDemo1() {
        let testUrl = "http://192.168.1.103:8111/quotation/getCurrentDataByCondition?findType=1&pageNum=1&pageSize=2000&firstCategoryId=4"

        
        let session = Session(startRequestsImmediately:false)
        
        let request = session.request(testUrl,headers: ["aaa":"bbb"])

       request.response { (dataResponse) in
                debugPrint(2)
                debugPrint(dataResponse)
            }
        request.resume()
    }
    
    func testUpload() {
        
//        ///普通的上传数据
//        let uploadReq = AF.upload(Data(), to: "www.xxx.com",headers: ["content-type":"MIME"])
//        uploadReq.responseJSON { (dataResp) in
//            debugPrint(dataResp)
//        }
        
        if  let inputStream = InputStream.init(fileAtPath: "xxx.file") {
            
            let inputStreamUploadRequest = AF.upload(inputStream, to: "www.xxx.com", method: .post, headers: nil, interceptor: nil, fileManager: .default, requestModifier: nil)
            inputStreamUploadRequest.response { (dataResp) in
                
            }
        }
        

    }

}




