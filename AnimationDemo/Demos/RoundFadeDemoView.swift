//
//  RoundFadeDemoView.swift
//  AnimationDemo
//
//  Created by apple on 2021/10/20.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit
class RoundFadeDemoView:UIView {
    
    let startBtn = UIButton.init(type: .system)
    let stopBtn = UIButton.init(type: .system)
    lazy private(set) var animationItems = [CALayer]()
    lazy private(set) var itemRadians = [CGFloat]()
    lazy private(set) var animationIsStarted = false
    lazy private(set) var isShowAnimFlag = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    override func layoutSubviews() {
        startBtn.frame = .init(x: 0, y: 0.8 * bounds.height, width: bounds.width * 0.5, height: 0.2 * bounds.height)
        stopBtn.frame = .init(x: 0.5 * bounds.width, y: startBtn.frame.minY, width: startBtn.frame.width, height: startBtn.frame.height)
        let side = min(bounds.size.width, bounds.size.height)
        let itemSize = side / CGFloat(animationItems.count + 2)
        let (positions, itemRadians) = getItemPositionsAndRadians(for: CGFloat.pi / 2.0 )
        self.itemRadians = itemRadians
        for i in 0..<animationItems.count {
            let item = animationItems[i]
            item.bounds = .init(origin: .zero, size: .init(width: itemSize, height: itemSize))
            item.position = positions[i]
        }
    }
    
    
    func getItemPositionsAndRadians(for startRadian:CGFloat,offsetRandian:CGFloat = 0.0) -> ([CGPoint],[CGFloat]) {
        let side = min(bounds.size.width, bounds.size.height)
        let itemSize = side / CGFloat(animationItems.count + 2)
        let center:CGPoint = .init(x: 0.5 * side, y: 0.5 * side)
        let start:CGFloat = startRadian
        let dr = 2.0 * CGFloat.pi / 10.0
        let r = side * 0.5 - itemSize
        var positions = [CGPoint]()
        var radians = [CGFloat]()
        for i in 0..<animationItems.count {
            let radian = start + CGFloat(i) * dr + offsetRandian
            positions.append(.init(x: center.x + cos(radian) * r, y: center.y + sin(radian) * r))
            radians.append(radian)
            
        }
        return (positions,radians)
    }
    
    func commonInit() {
        startBtn.setTitle("开始", for: .normal)
        startBtn.addTarget(self, action: #selector(btnTouched(_:)), for: .touchUpInside)
        stopBtn.setTitle("停止", for: .normal)
        stopBtn.addTarget(self, action: #selector(btnTouched(_:)), for: .touchUpInside)
        addSubview(stopBtn)
        addSubview(startBtn)
        stopBtn.isEnabled = false
        let numOfItems = 6
        for i in 0..<numOfItems {
            let layerItem = CATextLayer()
            layerItem.alignmentMode = .center
            layerItem.string =  NSAttributedString(string: "\(i + 1)", attributes: [
                .font:UIFont.systemFont(ofSize: 20.0),
                .foregroundColor:UIColor.white
            ])
            layerItem.backgroundColor = UIColor.random.cgColor
            layer.addSublayer(layerItem)
            animationItems.append(layerItem)
        }
    }
    
    @objc func btnTouched(_ sender:UIButton) {
        guard
            itemRadians.count > 0  else { return }
        
        startBtn.isEnabled = (sender == stopBtn)
        stopBtn.isEnabled = (sender == startBtn)
        if sender == stopBtn && animationIsStarted == true {
            animationIsStarted = false
            return
        }
        
        if sender == startBtn {
            animationIsStarted = true
        }

        func startAnimation() {
            
            let (positions,radians) = getItemPositionsAndRadians(for: itemRadians.first!,offsetRandian: CGFloat.pi)
            let duration:CGFloat = 0.5
            let perDeylay:CGFloat = duration / CGFloat(animationItems.count)
            var i = animationItems.count - 1
            let toOpactiy:Float = isShowAnimFlag ? 1.0 : 0.0
            while i >= 0 {
                let item = animationItems[i]
                
                performRoundFadeAnimation(
                    for: item,
                       duration: duration,
                       delay: CGFloat(animationItems.count - i) * perDeylay,
                       pathStartRadian: itemRadians[i],
                       pathEndRadian: radians[i],
                       toPosition: positions[i],
                       fromOpacity: item.opacity,
                       toOpacity: toOpactiy)
                i -= 1
            }
            
            itemRadians = radians
            isShowAnimFlag = !isShowAnimFlag
            
            DispatchQueue.main.asyncAfter(deadline: .now() + duration + CGFloat(animationItems.count) * perDeylay) {
                if self.animationIsStarted {
                    startAnimation()
                }
            }
        }
        startAnimation()
    }
}


extension RoundFadeDemoView {
    
    func
    performRoundFadeAnimation(
        for item:CALayer,
        duration:CFTimeInterval,
        delay:CFTimeInterval,
        pathStartRadian:CGFloat,
        pathEndRadian:CGFloat,
        toPosition:CGPoint,
        fromOpacity:Float,
        toOpacity:Float
    )
    {
        
        let side = min(bounds.size.width, bounds.size.height)
        let itemSize = side * 0.1
        let r = side * 0.5 - itemSize
        item.performRoundPathChangePositionOpacityAnim(duration: duration, delay: delay, pathArcCenter: .init(x: 0.5 * side, y: 0.5 * side), pathStartRadian: pathStartRadian, pathEndRadian: pathEndRadian, pathRadius: r, toPosition: toPosition, fromOpacity: fromOpacity, toOpacity: toOpacity)
        
    }
    
}
