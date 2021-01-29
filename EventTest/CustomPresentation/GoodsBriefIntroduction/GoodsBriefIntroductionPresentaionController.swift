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
struct  GoodsBriefIntroductionPresentaionControllerGenerator:PresentationControllerGenerator {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController {
        return GoodsBriefIntroductionPresentaionController.init(presentedViewController: presented, presenting: presenting)
    }
}

class GoodsBriefIntroductionPresentaionController: DefaultPresentationController {

    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        self.isAllowTouchDismiss = false
        self.isAllowPanDismiss = false
        
        
    }
    
    
    //MARK:-
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        if let _presentedView =  self.presentedView {
            let cornerPath = UIBezierPath.init(roundedRect: _presentedView.bounds, byRoundingCorners: [.topLeft,.topRight], cornerRadii: .init(width: 10, height: 10))
            let maskLayer = CAShapeLayer()
            maskLayer.path = cornerPath.cgPath
            _presentedView.layer.mask = maskLayer
            
        }
    }
    
    
    
}
