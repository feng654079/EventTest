//
//  DefaultAnimator.swift
//  EventTest
//
//  Created by apple on 2021/1/6.
//  Copyright © 2021 apple. All rights reserved.
//

import Foundation
//MARK: - UIViewControllerAnimatedTransitioning
class DefaultAnimator:NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard
            let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
            else {
                return
        }
        
        let containerView = transitionContext.containerView
        
        ///这里会获取为空,🤷‍♀️
        let fromView = transitionContext.view(forKey: .from)
        let toView = transitionContext.view(forKey: .to)
  
        
        let isPresenting = (toVC.presentingViewController == fromVC)
        
        let viewSize = CGSize(width: UIScreen.main.bounds.width, height: 0.4 * UIScreen.main.bounds.height)
        
        let duration = self.transitionDuration(using: transitionContext)
        
        if isPresenting {
            
            toView!.frame =  CGRect(x: 0, y: UIScreen.main.bounds.height, width: viewSize.width, height: viewSize.height)
            containerView.addSubview(toView!)
            
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.80, initialSpringVelocity: 0, options: [.allowUserInteraction,.beginFromCurrentState], animations: {
            
                toView!.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - viewSize.height, width: viewSize.width, height: viewSize.height)
                
                
            }) { (finished) in
                  transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        } else {
            
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.80, initialSpringVelocity: 0, options: [.allowUserInteraction,.beginFromCurrentState], animations: {
                
                    fromView!.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: viewSize.width , height: viewSize.height)
                    
            }) { (finished) in
                
                 fromView!.removeFromSuperview()
                 transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
    
    }
}
