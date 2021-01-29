//
//  DefaultInteractiveController.swift
//  CustomTrastionDemo
//
//  Created by Ifeng科技 on 2020/6/9.
//  Copyright © 2020 Ifeng科技. All rights reserved.
//

import Foundation
import UIKit

class DefaultInteractiveController:UIPercentDrivenInteractiveTransition {
    
    //MARK: overriden
    private var _transitionContext : UIViewControllerContextTransitioning?
    private var _panGesture: UIPanGestureRecognizer?
    
    var inTransitionContext:UIViewControllerContextTransitioning?
    
    init(panGestureRecognizer:UIPanGestureRecognizer) {
        super.init()
        panGestureRecognizer.addTarget(self, action: #selector(_handleSwipeUpdate(pan:)))
    }
    
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        _transitionContext = transitionContext
        super.startInteractiveTransition(transitionContext)
    }
    
    deinit {
        self._panGesture?.removeTarget(self, action: #selector(_handleSwipeUpdate(pan:)))
    }
    
    @objc private func _handleSwipeUpdate(pan:UIPanGestureRecognizer) {
       
        guard let context = _transitionContext else {
            return
        }
        let containerView = context.containerView
        
        let tranlation = pan.translation(in: pan.view)
        //let tranlation = pan.location(in: pan.view)
        let percent = CGFloat(fabsf(Float(tranlation.y / containerView.bounds.height)))
        if pan.state == .began {
            pan.setTranslation(.zero, in: containerView)
        } else if pan.state == .changed {
            self.update(percent)
        } else if pan.state == .ended {
            if percent > 0.2 {
                self.finish()
            } else {
                debugPrint("cancel")
                self.cancel()
            }
        } else {
            self.cancel()
        }
    }
}




