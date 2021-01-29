//
//  CustomTrastionDelegate.swift
//  CustomTrastionDemo
//
//  Created by Ifeng科技 on 2020/6/8.
//  Copyright © 2020 Ifeng科技. All rights reserved.
//

import Foundation
import UIKit

//MARK:- animator generators

enum TrasitionAnimatorType {
    case presentationAnimator(presented:UIViewController , presenting:UIViewController , source:UIViewController)
    case dismissalAnimator(dismissed:UIViewController)
}

//MARK:- interactionControl generators
enum InteractionControllerType {
    case presentation(animator: UIViewControllerAnimatedTransitioning)
    case dismissal(animator: UIViewControllerAnimatedTransitioning)
}


//MARK:-
class TrastionDelegate:NSObject {
    
    typealias AnimatedTransitioningGenerator = (_ type:TrasitionAnimatorType) -> UIViewControllerAnimatedTransitioning?
    typealias InteractionControllerGenerator = (_ type:InteractionControllerType) -> UIViewControllerInteractiveTransitioning?
    typealias PresentationControllerGenerator = (_ presented: UIViewController, _ presenting: UIViewController?, _ source: UIViewController) -> UIPresentationController?
    
    private var _animatorGenerator:AnimatedTransitioningGenerator?
    private var _interactionControllerGenerator: InteractionControllerGenerator?
    private var _presentationControllerGenerator:PresentationControllerGenerator?


    /// 创建
    /// - Parameters:
    ///   - animator: 负责动画效果
    ///   - interactionController: 交互动画的控制
    ///   - presentationController: 呈现控制器
    init(
          animator: AnimatedTransitioningGenerator?,
          interactionController: InteractionControllerGenerator?,
          presentationController: PresentationControllerGenerator?
        ) {
     
        _animatorGenerator = animator
        _interactionControllerGenerator = interactionController
        _presentationControllerGenerator = presentationController
    
        super.init()
        
    }
    
  
    deinit {
         debugPrint("TrastionDelegate deinit")
    }
   

}

//MARK:-
extension TrastionDelegate:UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
       return  _animatorGenerator?(.presentationAnimator(presented: presented, presenting: presenting, source: source))
        
    }

    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return _animatorGenerator?(.dismissalAnimator(dismissed: dismissed))
    }

       
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
       return _interactionControllerGenerator?(.presentation(animator: animator))
    }

       
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return _interactionControllerGenerator?(.dismissal(animator: animator))
    }

       
    @available(iOS 8.0, *)
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return _presentationControllerGenerator?(presented,presenting,source)
    }
}
