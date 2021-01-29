//
//  ConfirmPublishAnimationController.swift
//  QuanPin
//
//  Created by Ifeng科技 on 2020/6/28.
//  Copyright © 2020 Ifeng科技. All rights reserved.
//

import Foundation
import UIKit

struct RelieveBindingTipAnimatorControllerGenerator :AnimatedTransitioningGenerator{
    func animatedTransitioning(for type: TrasitionAnimatorType) -> UIViewControllerAnimatedTransitioning {
        return ConfirmPublishAnimationController(animtorType: type)
    }
}

class RelieveBindingTipAnimatorAnimationController : DefaultAnimator {
  
    deinit {
        debugPrint("ConfirmPublishAnimationController deinit")
    }
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVc = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) else {
                return
        }
        
        toVC.view.translatesAutoresizingMaskIntoConstraints = false
        let constraints = toVC.view.widthAnchor.constraint(equalToConstant: 300)
        constraints.priority = .defaultHigh + 1
        //let constraints = toVC.view.widthAnchor.constraint(greaterThanOrEqualToConstant: 300.hs)
        constraints.isActive = true
        let viewSize = toVC.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        constraints.isActive = false
        
//        let viewSize = CGSize(width: 300.hs, height: 180.hs)
        
        let duration = self.transitionDuration(using: transitionContext)
        
        switch type {
            
        case .presentationAnimator(_,_,_):
            toVC.view.layer.cornerRadius = 5.0
            toVC.view.clipsToBounds = true
            
            toVC.view.frame = CGRect(x: (UIScreen.main.bounds.width - viewSize.width) * 0.5, y: UIScreen.main.bounds.height, width: viewSize.width, height: viewSize.height)
            transitionContext.containerView.addSubview(toVC.view)
            
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.80, initialSpringVelocity: 0, options: [.allowUserInteraction,.beginFromCurrentState], animations: {
                
                toVC.view.frame = CGRect(x:  (UIScreen.main.bounds.width - viewSize.width) * 0.50, y: 132.0, width: viewSize.width, height: viewSize.height)
                
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
