//
//  WxApiManager.swift
//  EventTest
//
//  Created by apple on 2020/12/10.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

class WxApiManager:NSObject {
    static let shared = WxApiManager()
}

extension WxApiManager {
    
    /// 分享场景
    enum WXShareScene {
        ///会话
        case session
        ///朋友圈
        case timeline
        /// 收藏
        case favorite
        ///制定会话
        case specifiedSession
        
        func asWXScene() -> Int32 {
            switch self {
            case .session:
                return Int32(WXSceneSession.rawValue)
            case .timeline:
                return Int32(WXSceneTimeline.rawValue)
            case .favorite:
                return Int32(WXSceneFavorite.rawValue)
            case .specifiedSession:
                return Int32(WXSceneSpecifiedSession.rawValue)
            }
        }
    }
    
    /// 分享网页链接地址
    /// - Parameters:
    ///   - webpageUrl: 网页链接
    ///   - scene: 分享的场景
    ///   - title: 标题
    ///   - thumbImage: 缩略图
    ///   - completion: 回调
    func shareWebpage
    (
        webpageUrl:String,
        scene:WXShareScene,
        title:String,
        thumbImage:UIImage,
        completion: @escaping (Bool) -> Void
    ) {
        let webpageObject = WXWebpageObject()
        webpageObject.webpageUrl = webpageUrl
        let msg = WXMediaMessage()
        msg.title = title
        msg.setThumbImage(thumbImage)
        msg.mediaObject = webpageObject
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = msg
        req.scene = scene.asWXScene()
        WXApi.send(req, completion: completion)
    }
}


extension WxApiManager:WXApiDelegate {
   
    func onReq(_ req: BaseReq) {
        
    }
    
    func onResp(_ resp: BaseResp) {
       
        if resp.errCode != WXSuccess.rawValue {
            let currentVC = UIViewController.getCurrentController()
            currentVC?.showAlert(msg: "WXERR: code:\(resp.errCode) msg: \(resp.errStr)")
        }
    }
}

extension UIViewController {
    
    
    static func getCurrentController() -> UIViewController? {
        if #available(iOS 13.0, *) {
           //get foreground and onscreen scence
            let targetScenes:UIScene? = UIApplication.shared.connectedScenes.first { (scene) -> Bool in
                return scene.activationState == .foregroundActive
                    && scene.isKind(of: UIWindowScene.self)
            }
        
            if
                let tsDelegate = targetScenes?.delegate as? UIWindowSceneDelegate,
                let targetWindow = tsDelegate.window as? UIWindow {
                return getCurrentViewController(from: targetWindow)
            }
           
        }
        if let targetWindow = UIApplication.shared.windows.last {
            return getCurrentViewController(from: targetWindow)
        }
        return nil
    }

    
    static  func getCurrentViewController(from window:UIWindow) -> UIViewController? {
        var lastResponder:UIResponder? = window.subviews.last
        while lastResponder != nil {
            if let vc = lastResponder!.next as? UIViewController {
                return vc
            }
            lastResponder = lastResponder?.next
        }
        return nil
    }
    
    func showAlert(msg:String) {
        let alertController = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "确定", style: UIAlertAction.Style.default) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

