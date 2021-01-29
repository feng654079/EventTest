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

struct  ConfirmPublishPresentationControllerGenerator:PresentationControllerGenerator {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController {
        return ConfirmPublishPresentationController.init(presentedViewController: presented, presenting: presenting)
    }
}

class ConfirmPublishPresentationController: DefaultPresentationController {
    lazy private var _closeBtn:UIButton  =  {
        let btn = UIButton(frame: .init(x: 0, y: 0, width: 40, height: 40))
        btn.setImage(UIImage(named: "close_round_white"), for: .normal)
        btn.addTarget(self, action: #selector(_closeBtnTouched(sender:)), for: .touchUpInside)
        return btn
    }()
    
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        self.isAllowTouchDismiss = true
        self.isAllowPanDismiss = false
        
     
    }
    
    
    //MARK:-
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        if let _presentedView =  self.presentedView {
            _presentedView.layer.cornerRadius = 4.0
            _presentedView.layer.masksToBounds = true
        }
    }
    

    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        _addCloseBtn()
        
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        _removeCloseBtn()
    }
    
    
    @objc private func _closeBtnTouched(sender:UIButton) {
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    
    private func _addCloseBtn() {
        if let _presentedView =  self.presentedView,
            let _containerView = self.containerView {
            _closeBtn.frame = .init(x: _presentedView.center.x - 0.5 * _closeBtn.bounds.width, y: _presentedView.frame.maxY + 10, width: _closeBtn.bounds.width, height: _closeBtn.bounds.height)
            _containerView.addSubview(_closeBtn)
        }
    }
    
    private func _removeCloseBtn() {
        _closeBtn.removeFromSuperview()
    }
    
 
    
}
