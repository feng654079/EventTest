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
        let testUrl = "http://192.168.1.103:8111/quotation/getCurrentDataByCondition?findType=1&pageNum=1&pageSize=2000&firstCategoryId=4"

        let request = AF.request(testUrl,headers: ["aaa":"bbb"])

       request.response { (dataResponse) in
                debugPrint(2)
                debugPrint(dataResponse)
            }
        
        
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




