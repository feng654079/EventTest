//
//  RxChangeUIStateVC.swift
//  EventTest
//
//  Created by apple on 2020/11/12.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

protocol RequestService {
    func mockRequest() -> Observable<Bool>
}

enum RequestServiceError:Error {
    case mockError(msg:String)
}

class DefaultRequestService: RequestService {
 
    static let shared = DefaultRequestService()
    
    private static var flag = 0
    func mockRequest() -> Observable<Bool> {
        let seq = Observable<Bool>.create { (observer) -> Disposable in
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                if DefaultRequestService.flag % 3 == 0 {
                    observer.onNext(true)
                    observer.onCompleted()
                }
                else if DefaultRequestService.flag % 3 == 1 {
                    observer.onNext(false)
                    observer.onCompleted()
                }
                else {
                    observer.onError(RequestServiceError.mockError(msg: "被模拟的请求错误"))
                }
                DefaultRequestService.flag += 1
            }
            return Disposables.create()
        }
        
        return seq
    }
    
    
}


class RxChangeUIStateViewModel {
    typealias Input = (Observable<Void>)
    
    let outRequest:Observable<Bool>
    //let outRequesting:Observable<Bool>
    
    init(input:Input,service:RequestService) {
        let btnTap = input
    
        outRequest =  btnTap.flatMap {
            return service.mockRequest()
                .observeOn(MainScheduler.instance)
                .catchErrorJustReturn(false)
        }.share(replay: 1)
        
    }
    
    deinit {
        debugPrint("RxChangeUIStateViewModel deinit")
    }
}




class RxChangeUIStateVC: UIViewController {
    @IBOutlet weak var mockRequestBtn: UIButton!
    
    let disposeBag = DisposeBag()
    
    deinit {
        debugPrint("RxChangeUIStateVC deinit")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ///UI交互
        let btnInput = mockRequestBtn.rx.tap.asObservable()
        
        ///将UI交互的序列注入 ViewModel
        let viewModel = RxChangeUIStateViewModel(
            input: (btnInput),
            service: DefaultRequestService.shared)
        
        ///需要更改的UI状态
        let btnTitle = mockRequestBtn.rx.title(for: .normal)
        
        ///点击时修改按钮文字
        btnInput.map {
            return "请求中..."
        }
        .bind(to:btnTitle)
        .disposed(by: disposeBag)
        
        ///请求结果展示在btn上
        viewModel.outRequest
            .map {
                return "请求结果\($0)"
            }
            .bind(to :btnTitle)
            .disposed(by: disposeBag)
        
//        do {
//
//            let password: [UInt8] = Array("123456".utf8)
//            let salt: [UInt8] = Array(" a piece of salt".utf8)
//            do {
//                let key = try PKCS5.PBKDF2(
//                    password: password, salt: salt, iterations: 4096, keyLength: 32, variant: .sha256
//                ).calculate()
//
//                let iv = AES.randomIV(AES.blockSize)
//
//                let aes = try AES.init(key: key, blockMode: CBC(iv: iv), padding: .pkcs7)
//
//                let inputData = "你好世界,hello world,123456".data(using: .utf8)!
//
//                let encryptedBytes = try aes.encrypt(inputData.bytes)
//                let encryptedData = Data(encryptedBytes)
//
//                debugPrint("encryptedData:\(encryptedBytes.toBase64())")
//                let decryptedBytes = try aes.decrypt(encryptedData.bytes)
//                let decryptedData = Data(decryptedBytes)
//
//                debugPrint("decrypted string:\(String(data: decryptedData, encoding: .utf8)!)")
//            } catch let error {
//                debugPrint(error)
//            }
//        }
        
//        do {
//            let aes = try AES(key: "keykeykeykeykeyk", iv: "drowssapdrowssap") // aes128
//            let encryptBytes = try aes.encrypt(Array("你好,世界, hello world".utf8))
//            let base64Str = encryptBytes.toBase64()
//
//            let fromBase64Bytes = try base64Str!.decryptBase64(cipher: aes)
//            let decryptBytes = try aes.decrypt(Data(encryptBytes).bytes)
//            debugPrint("decryptText:\(String(data: Data(fromBase64Bytes), encoding: .utf8))")
//        } catch let error {
//            debugPrint(error)
//        }
        
        do {

            var aInt = 0
            
            struct TTT {
                var a: Int
            }
            var b = TTT(a: 10)
            
            let block1 = {
                b.a = 11
                aInt = 1
            }
            
            let block2 = {
                b.a = 12
                aInt = 2
            }
            
            block1()
            debugPrint(b.a,aInt) //11 1
            block2()
            debugPrint(b.a,aInt) //12 2
           
        }
        
        let dic = ["a":1]
        let v = dic["b",default: 0]
        debugPrint()
    }
}

