//
//  UIViewController+CustomTranstion.swift
//  CustomTrastionDemo
//
//  Created by Ifeng科技 on 2020/6/8.
//  Copyright © 2020 Ifeng科技. All rights reserved.
//

import Foundation
import UIKit

/**
 参考代码: https://developer.apple.com/library/archive/samplecode/CustomTransitions/Introduction/Intro.html#//apple_ref/doc/uid/TP40015158
 */

extension UIViewController {
    func showToolBarPresent(viewController:UIViewController ,
                 animated:Bool = true,
                 completion: (() -> Void)? = nil) {
      
        let dp = DefaultPresentationController(presentedViewController: viewController, presenting: self)
        let transitionDelegate = TrastionDelegate { (type) -> UIViewControllerAnimatedTransitioning? in
            return DefaultAnimator()
        } interactionController: { (type) -> UIViewControllerInteractiveTransitioning? in
            return dp.interactiveController
        } presentationController: { (p, pi, s) -> UIPresentationController? in
            return dp
        }
        customPresent(viewController:
             viewController,transitioningDelegate:transitionDelegate)
    }
}


extension UIViewController {

    func customPresent(viewController:UIViewController,
                       animated:Bool = true,
                       transitioningDelegate:TrastionDelegate,
                       modalPresentationCapturesStatusBarAppearance:Bool = true,
                       completion: (() -> Void)? = nil ) {
        viewController.modalPresentationStyle = .custom
        viewController.modalPresentationCapturesStatusBarAppearance = modalPresentationCapturesStatusBarAppearance
        viewController.transitioningDelegate = transitioningDelegate
        viewController.storedTransitioningDelegate = transitioningDelegate
        self.present(viewController, animated: animated, completion: completion)
    }
}

extension UIViewController {
    private struct AssociationKey {
        static var transitioningDelegate = "storedTransitioningDelegate"
    }
    ///引用delegate 防止被释放
    var storedTransitioningDelegate:TrastionDelegate? {
        set {
            objc_setAssociatedObject(self, &AssociationKey.transitioningDelegate, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }

        get {
            return objc_getAssociatedObject(self,  &AssociationKey.transitioningDelegate) as? TrastionDelegate
        }
    }
}
