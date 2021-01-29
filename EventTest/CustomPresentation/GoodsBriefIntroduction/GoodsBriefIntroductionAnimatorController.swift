//
//  ConfirmPublishAnimationController.swift
//  QuanPin
//
//  Created by Ifeng科技 on 2020/6/28.
//  Copyright © 2020 Ifeng科技. All rights reserved.
//

import Foundation
import UIKit

struct GoodsBriefIntroductionAnimatorControllerGenerator :AnimatedTransitioningGenerator{
    let height:CGFloat
    
    func animatedTransitioning(for type: TrasitionAnimatorType) -> UIViewControllerAnimatedTransitioning {
        let c = GoodsBriefIntroductionAnimatorController(animtorType: type)
        c.pViewHeight = height
        return c
    }
}

class GoodsBriefIntroductionAnimatorController : DefaultAnimator {
  
    
    override init(animtorType:TrasitionAnimatorType) {
        super.init(animtorType:animtorType)
        
    }
    
    var pViewHeight:CGFloat = UIScreen.main.bounds.height * 587.0 / 667.0
    
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVc = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) else {
                return
        }
        
        //let viewSize = UIScreen.main.bounds.size
        let viewHeight = min(UIScreen.main.bounds.height * 587.0 / 667.0,pViewHeight)
        
        let viewSize = CGSize(width: UIScreen.main.bounds.width, height:viewHeight)
        
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
