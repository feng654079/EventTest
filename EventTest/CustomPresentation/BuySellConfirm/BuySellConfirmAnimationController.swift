//
//  BuySellConfirmAnimationController.swift
//  QuanPin
//
//  Created by Ifeng科技 on 2020/6/30.
//  Copyright © 2020 Ifeng科技. All rights reserved.
//

import Foundation
import UIKit
//
//  ConfirmPublishAnimationController.swift
//  QuanPin
//
//  Created by Ifeng科技 on 2020/6/28.
//  Copyright © 2020 Ifeng科技. All rights reserved.
//

import Foundation

struct BuySellConfirmAnimationControllerGenerator :AnimatedTransitioningGenerator {
    
    func animatedTransitioning(for type: TrasitionAnimatorType) -> UIViewControllerAnimatedTransitioning {
     
        return BuySellConfirmAnimationController(animtorType: type)
    }
}

class BuySellConfirmAnimationController : DefaultAnimator {
  
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVc = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) else {
                return
        }
        
        
        let constraints = toVC.view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        constraints.priority = .defaultHigh + 1
        //let constraints = toVC.view.widthAnchor.constraint(greaterThanOrEqualToConstant: 300.hs)
        constraints.isActive = true
        let viewSize = toVC.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        constraints.isActive = false
        
        //let viewSize = CGSize(width: 375.0.hs, height:500)
        
        
        let duration = self.transitionDuration(using: transitionContext)
        
        switch type {
            
        case .presentationAnimator(_,_,_):
            
            toVC.view.frame = CGRect(x: (UIScreen.main.bounds.width - viewSize.width) * 0.5, y: UIScreen.main.bounds.height, width: viewSize.width, height: viewSize.height)
            transitionContext.containerView.addSubview(toVC.view)
            
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.80, initialSpringVelocity: 0, options: [.allowUserInteraction,.beginFromCurrentState], animations: {
                
                toVC.view.frame = CGRect(x:  (UIScreen.main.bounds.width - viewSize.width) * 0.50, y: UIScreen.main.bounds.height - viewSize.height, width: viewSize.width, height: viewSize.height)
                
            }) { (finished) in
                
                  transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
            
        case .dismissalAnimator(_):
            
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.80, initialSpringVelocity: 0, options: [.allowUserInteraction,.beginFromCurrentState], animations: {
                
                    fromVc.view.frame = CGRect(x: (UIScreen.main.bounds.width - viewSize.width) * 0.50, y: UIScreen.main.bounds.height, width: viewSize.width , height: viewSize.height)
                
                    
            }) { (finished) in
                fromVc.view.removeFromSuperview()
               
                 transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
            
        }
        
    }
    
    
}
