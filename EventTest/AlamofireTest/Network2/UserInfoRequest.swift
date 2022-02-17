//
//  UserInfoRequest.swift
//  DAppDemo
//
//  Created by apple on 2021/9/27.
//

import Foundation

//MARK:- 用户信息请求
struct UserInfoRequest:Request {
   
    var path: String = "/userxxx/info"
    var method: HTTPMethod = .GET
    var parameters: [String : String]? = nil
    

}
