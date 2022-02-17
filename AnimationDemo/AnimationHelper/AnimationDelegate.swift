//
//  AnimationDelegate.swift
//  AnimationDemo
//
//  Created by apple on 2021/10/19.
//  Copyright © 2021 apple. All rights reserved.
//

import Foundation
import QuartzCore


class AnimationDelegate:NSObject {
    typealias AnimationStartCallback = (_ anim:CAAnimation) -> Void
    typealias AnimationStopCallback = (_ anim:CAAnimation,_ isFinished:Bool) -> Void
    
   let animationDidStartCallback:AnimationStartCallback?
   let animationDidStopCallback:AnimationStopCallback?
    
    
    weak var layer:CALayer? = nil 
    
    init(didStartCallback:AnimationStartCallback?,didStopCallback:AnimationStopCallback?) {
        self.animationDidStartCallback = didStartCallback
        self.animationDidStopCallback = didStopCallback
    }
}

extension AnimationDelegate: CAAnimationDelegate {
    func animationDidStart(_ anim: CAAnimation) {
        animationDidStartCallback?(anim)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        animationDidStopCallback?(anim,flag)
    }
    
}
