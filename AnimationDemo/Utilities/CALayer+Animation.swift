//
//  CALayer+Ex.swift
//  AnimationDemo
//
//  Created by apple on 2021/10/20.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit

//MARK: - 
extension CALayer {
    func
    performChangePositionYAndOpacityAnimation(
        duration:CFTimeInterval,
        delay:CFTimeInterval,
        fromPositionY:CGFloat,
        toPositionY:CGFloat,
        fromOpacity:Float,
        toOpacity:Float)
    {
        let animationKey = "CALayer.Animation" + ".changePositionYAndOpacityAnimKey"
        let item = self
        let yMoveDownAnim = CABasicAnimation.init(keyPath: AnimationKeyPath.positionY.rawValue)
        yMoveDownAnim.duration = duration
        yMoveDownAnim.fromValue = fromPositionY
        yMoveDownAnim.toValue = toPositionY
        
        let hiddenAnim = CABasicAnimation(keyPath: AnimationKeyPath.opacity.rawValue)
        hiddenAnim.toValue = toOpacity
        hiddenAnim.fromValue = fromOpacity
        hiddenAnim.duration = duration
        
        let group = CAAnimationGroup()
        group.animations = [yMoveDownAnim,hiddenAnim]
        group.duration = duration
        group.fillMode = .forwards
        group.isRemovedOnCompletion = false
        group.beginTime = CACurrentMediaTime() + delay
        
        let animationDelegate = AnimationDelegate(didStartCallback: nil) {
            [weak item]
            anim, isFinished in
            guard
                let it = item
            else { return }
            it.position = .init(x: it.position.x, y: toPositionY)
            it.opacity = toOpacity
            if isFinished {
                item?.removeAnimation(forKey: animationKey)
            }
        }
        group.delegate = animationDelegate
        item.add(group, forKey: animationKey)
    }
   
}


//MARK: -
extension CALayer {

    func
    performRoundPathChangePositionOpacityAnim(
        duration:CFTimeInterval,
        delay:CFTimeInterval,
        pathArcCenter:CGPoint,
        pathStartRadian:CGFloat,
        pathEndRadian:CGFloat,
        pathRadius:CGFloat,
        clockwise:Bool = true,
        toPosition:CGPoint,
        fromOpacity:Float,
        toOpacity:Float
    )
    {
        let item = self
        let moveAnim = CAKeyframeAnimation(keyPath: AnimationKeyPath.position.rawValue)
        moveAnim.duration = duration
        moveAnim.path = UIBezierPath.init(arcCenter: pathArcCenter, radius: pathRadius, startAngle: pathStartRadian, endAngle: pathEndRadian, clockwise: clockwise).cgPath
        
        let opacityAnim = CABasicAnimation(keyPath: AnimationKeyPath.opacity.rawValue)
        opacityAnim.fromValue = fromOpacity
        opacityAnim.toValue = toOpacity
        opacityAnim.duration = duration
        
        let group = CAAnimationGroup()
        group.beginTime = CACurrentMediaTime() + delay
        group.animations = [moveAnim,opacityAnim]
        group.duration = duration
        group.fillMode = .forwards
        group.isRemovedOnCompletion = false
        let animationKey = "CALayer.performRoundPathChangePositionOpacityAnim"
        let animDelegate = AnimationDelegate(didStartCallback: nil) {
            [weak item]
            anim, isFinished in
            guard
                let it = item
            else { return }
            it.position = toPosition
            it.opacity = toOpacity
            if isFinished {
                item?.removeAnimation(forKey: animationKey)
            }
        }
        group.delegate = animDelegate
        item.add(group, forKey: animationKey)
        
    }
}

//MARK: -

extension CALayer {
    
    func
    performPathAnimation(
        for animationKey:String,
        duration:CFTimeInterval,
        delay:CFTimeInterval,
        path:UIBezierPath,
        toPosition:CGPoint,
        fromColor:CGColor,
        toColor:CGColor,
        repeatCount:Float = 1,
        animationDelegate:AnimationDelegate? = nil
    ) {
    
        let moveAnimation = CAKeyframeAnimation(keyPath: AnimationKeyPath.position.rawValue)
        moveAnimation.path = path.cgPath
        moveAnimation.duration = duration
        moveAnimation.calculationMode = .cubic
        
        let colorAnimation = CABasicAnimation(keyPath: AnimationKeyPath.backgroundColor.rawValue)
        colorAnimation.fromValue = fromColor
        colorAnimation.toValue = toColor
        colorAnimation.duration = duration
        
        
        let group = CAAnimationGroup()
        group.animations = [moveAnimation,colorAnimation]
        group.duration = duration
        group.fillMode = .forwards
        group.isRemovedOnCompletion = false
        group.repeatCount = repeatCount
        group.delegate = animationDelegate
        
        self.add(group, forKey: animationKey)
        
        
    }
    
}
