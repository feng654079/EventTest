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

       let request = AF.request(testUrl)

       request.response { (dataResponse) in
                debugPrint(2)
                debugPrint(dataResponse)
            }
    }

}




