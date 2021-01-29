//
//  JDAnimationController.swift
//  CustomTrastionDemo
//
//  Created by Ifeng科技 on 2020/6/9.
//  Copyright © 2020 Ifeng科技. All rights reserved.
//

import Foundation
import UIKit

struct JDAnimationControllerGenerator :AnimatedTransitioningGenerator {
    func animatedTransitioning(for type: TrasitionAnimatorType) -> UIViewControllerAnimatedTransitioning {
        return JDAnimationController(animtorType: type)
    }
    
    
}

class JDAnimationController: DefaultAnimator {
    
    override func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }
    
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let duration = self.transitionDuration(using: transitionContext)
        
        let viewSize = CGSize(width: UIScreen.main.bounds.width, height: 0.4 * UIScreen.main.bounds.height)
        
        switch type {
        case .presentationAnimator(let presented, let presenting,_):
            
            let statusBarH = UIApplication.shared.statusBarFrame.height
            
           presented.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: viewSize.width, height: viewSize.height)
            transitionContext.containerView.addSubview(presented.view)
            
            
            let scale = CGFloat(1.0 - statusBarH * 2.0 / presenting.view.bounds.height)
            var transform = CATransform3DIdentity
            transform.m34 = -1.0 / 1000.0
            transform = CATransform3DRotate(transform, CGFloat.pi / 16.0, 1.0, 0.0, 0.0)
            transform = CATransform3DTranslate(transform, 0, 0, -100)
            
            transitionContext.containerView.addSubview(presented.view)
            
            let tranformDuration = duration
            UIView.animate(withDuration: 0.6 * tranformDuration, delay: 0, options: .curveEaseInOut, animations: {
                presenting.view.layer.transform = transform
            }) { (_) in
                
                UIView.animate(withDuration: 0.3 * tranformDuration, animations: {
                                   presenting.view.layer.transform = CATransform3DMakeScale(scale, scale, 1.0)
                                   
                               })
            }
            
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.80, initialSpringVelocity: 0, options: /*[.allowUserInteraction,.beginFromCurrentState]*/.curveLinear, animations: {
                           
                             presented.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - viewSize.height, width: viewSize.width, height: viewSize.height)
                            // toVC.beginAppearanceTransition(false, animated: true)
                       }) { (finished) in
                           
                             transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                       }
            
        case .dismissalAnimator(let dismissed):
            UIView.animate(withDuration: 0.9 * duration, delay: 0, options: .curveEaseInOut, animations: {
                if let toVC = transitionContext.viewController(forKey: .to) {
                    toVC.view.layer.transform = CATransform3DIdentity
                }
            })
            
            
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.80, initialSpringVelocity: 0, options: [.allowUserInteraction,.beginFromCurrentState], animations: {
                
                dismissed.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: viewSize.width , height: viewSize.height)
                
            }) { (finished) in
                dismissed.view.removeFromSuperview()
                
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
            
            break
        }
        
    }
    
}


