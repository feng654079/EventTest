//
//  WxShareDemoVC.swift
//  EventTest
//
//  Created by apple on 2020/12/10.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import UIKit

class WxShareDemoVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        registerWxApi()
    }
    
    private func registerWxApi() {
        WXApi.startLog(by: .normal) { (txt) in
            debugPrint("\(txt)")
        }
        
        WXApi.registerApp("", universalLink: "")
    }
    
    @IBAction func shareBtnTouched(_ sender: Any) {
//        let miniProgramObj = WXMiniProgramObject()
//        miniProgramObj.webpageUrl = "http://www.qq.com"
//        miniProgramObj.miniProgramType = .preview
//        miniProgramObj.userName =  "wxa5b486c6b918ecfb" //"gh_d43f693ca31f"
//        miniProgramObj.path = "pages/media"
//
//        let msg = WXMediaMessage()
//        msg.title = "测试小程序"
//        msg.description = "小程序描述"
//        msg.thumbData = nil
//        msg.mediaObject = miniProgramObj
//
//        let req = SendMessageToWXReq()
//        req.bText = false
//        req.message = msg
//        req.scene = Int32(WXSceneSession.rawValue)
//        WXApi.send(req) { (success) in
//
//        }
        
        WxApiManager.shared
            .shareWebpage(webpageUrl: "", scene: .session, title: "", thumbImage: UIImage(named: "")!) { (isSuccess) in
            
        }
    }
}
