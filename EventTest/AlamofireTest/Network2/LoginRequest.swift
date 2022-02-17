//
//  LoginRequest.swift
//  DAppDemo
//
//  Created by apple on 2021/9/27.
//

import Foundation



//MARK:- 登录请求
///登录请求
struct LoginRequest:Request {
    
    var userName:String
    var password:String
    var path: String = "/auth/login"
    var method: HTTPMethod = .POST
    var parameters: [String : String]? {
        return ["mobile":userName,"password":password]
    }
    
   
}
