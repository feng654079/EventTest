//
//  ConfirmPublishPresentationController.swift
//  QuanPin
//
//  Created by Ifeng科技 on 2020/6/28.
//  Copyright © 2020 Ifeng科技. All rights reserved.
//

import Foundation
import UIKit

//MARK:- PresentationControllerGenerator
struct  BuySellPresentationControllerGenerator:PresentationControllerGenerator {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController {
        return BuySellPresentationController.init(presentedViewController: presented, presenting: presenting)
    }
}

class BuySellPresentationController: DefaultPresentationController {

    lazy private var _shadowView = UIView()
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        self.isAllowTouchDismiss = false
        self.isAllowPanDismiss = false
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHidden(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    
    //MARK:-
    override func presentationTransitionWillBegin() {
        //super.presentationTransitionWillBegin()
        if let _presentedView =  self.presentedView {
            let cornerPath = UIBezierPath.init(roundedRect: _presentedView.bounds, byRoundingCorners: [.topLeft,.topRight], cornerRadii: .init(width: 10, height: 10))
            let maskLayer = CAShapeLayer()
            maskLayer.path = cornerPath.cgPath
            _presentedView.layer.mask = maskLayer
            
        }
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        if let _presentedView =  self.presentedView {
//            _shadowView.frame =  _presentedView.frame
//            _shadowView.layer.backgroundColor = UIColor(hexString: "#DFDFDF").withAlphaComponent(0.5).cgColor
//            _shadowView.layer.shadowOpacity = 1.0
//            _shadowView.layer.shadowColor = UIColor(hexString: "#DFDFDF").cgColor
//            _shadowView.layer.shadowOffset = .init(width: 0, height: -4.0)
//            _shadowView.layer.shadowRadius = 10
//           
//
//            containerView?.insertSubview(_shadowView, belowSubview: _presentedView)
        }
    }
    
    override func dismissalTransitionWillBegin() {
        _shadowView.removeFromSuperview()
    }
    
    
    //MARK: -
    @objc func keyboardWillShow(_ noti:Notification) {
        
    }
    
    @objc func keyboardWillHidden(_ noti:Notification) {
    
        UIView.animate(withDuration: 0.2) {
            if let pv = self.presentedView {
                pv.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - pv.bounds.height, width: pv.bounds.width ,  height: pv.bounds.height)
                self._shadowView.frame = pv.frame
            }
        }
    }
    
}
