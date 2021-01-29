//
//  JDPresentationController.swift
//  CustomTrastionDemo
//
//  Created by Ifeng科技 on 2020/6/10.
//  Copyright © 2020 Ifeng科技. All rights reserved.
//

import Foundation
import UIKit

struct JDPresentationControllerGenerator:PresentationControllerGenerator {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController {
        return JDPresentationController(presentedViewController: presented, presenting: presenting)
    }
}


class  JDPresentationController : DefaultPresentationController{
    
    override var dismissTriggerProgress: CGFloat {
        return 0.3
    }
    
    override func progress(for pan:UIPanGestureRecognizer) -> CGFloat {
        let translation = pan.translation(in: self.containerView).y
        let percent = max(0, translation / self.presentedViewController.view.bounds.height)
        return percent
    }
    
    override func adjustUIState(with progress:CGFloat , animated:Bool) {
        
        guard
            let containerView = self.containerView,
            let presentedView = self.presentedView,
            let presentingView = self.presentingViewController.view
            else {
                return
        }
        
        let changeBlock = {
            let distance = containerView.bounds.height - presentedView.bounds.height
            presentedView.frame = CGRect(x: 0, y: distance + progress * distance, width: presentedView.bounds.width, height: presentedView.bounds.height)
            
            let alphaDistance:CGFloat = 0.5
            containerView.backgroundColor = UIColor.black.withAlphaComponent((1 - progress) * alphaDistance)
            
            let statusBarH = UIApplication.shared.statusBarFrame.height
            let scale = CGFloat(1.0 - statusBarH * 2.0 / presentingView.bounds.height)
            let sd:CGFloat = scale + (1.0 - scale) * progress
            presentingView.layer.transform = CATransform3DMakeScale(sd, sd, 0.0)
        }
        
        if animated {
            UIView.animate(withDuration: 0.2) {
                changeBlock()
            }
            
        } else {
            changeBlock()
        }
    }
}
