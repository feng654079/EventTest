//
//  MoveContinuousAnimationDemoView.swift
//  AnimationDemo
//
//  Created by apple on 2021/10/19.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit


///实现几个item 先后移除的效果
class ChangePositionAndOpacityDemoView:UIView  {
    
    let showBtn = UIButton.init(type: .system)
    let hiddenBtn = UIButton.init(type: .system)
    lazy private(set) var animationItems = [CALayer]()
    lazy private(set) var maxCountInLine:Int = 6
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    override func layoutSubviews() {
        showBtn.frame = .init(x: 0, y: 0.8 * bounds.height, width: 0.5 * bounds.width, height: 0.2 * bounds.height)
        hiddenBtn.frame = .init(x: 0.5 * bounds.width, y: 0.8 * bounds.height, width: 0.5 * bounds.width, height: 0.2 * bounds.height)
        
        let numOfItems = animationItems.count
        maxCountInLine = min(numOfItems, 6)
        let scale = 1.0 / CGFloat(maxCountInLine + 2)
        let itemSize = CGSize(width:scale * bounds.width, height: scale * bounds.width)
        let spacing = (bounds.width - CGFloat(maxCountInLine) * itemSize.width) / CGFloat(maxCountInLine + 1)
        for i in 0..<numOfItems {
            animationItems[i].position = CGPoint(x: spacing + CGFloat(i % maxCountInLine) * (spacing + itemSize.width), y: spacing + CGFloat(i / maxCountInLine) * (spacing + itemSize.height))
            animationItems[i].bounds = .init(origin: .zero, size: itemSize)
        }
    }
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
    }
    func commonInit() {
        showBtn.setTitle("显示", for: .normal)
        hiddenBtn.setTitle("隐藏", for: .normal)
        showBtn.addTarget(self, action: #selector(btnTouched(_:)), for: .touchUpInside)
        hiddenBtn.addTarget(self, action: #selector(btnTouched(_:)), for: .touchUpInside)
        showBtn.isEnabled = false
        addSubview(showBtn)
        addSubview(hiddenBtn)
        let numOfItems = 22
        for _ in 0..<numOfItems {
            let layerItem = CALayer()
            layerItem.anchorPoint = .zero
            layerItem.backgroundColor = UIColor.random.cgColor
            layer.addSublayer(layerItem)
            animationItems.append(layerItem)
        }
        
    }
    
    @objc func btnTouched(_ sender:UIButton) {
        let totalDuration:CFTimeInterval = 0.25
        let itemDelay = totalDuration / CFTimeInterval(maxCountInLine)

        if sender == showBtn {
            //点击了显示按钮
            for i in 0..<animationItems.count {
                let item = animationItems[i]
                performChangePositionYAndOpacityAnimation(for: item, duration: totalDuration, delay: CFTimeInterval(i % maxCountInLine) * itemDelay, fromPositionY: item.position.y, toPositionY: item.position.y - 200.0, fromOpacity: item.opacity, toOpacity: 1.0)
            }
        }
        else if sender == hiddenBtn {
            //点击了显示按钮
            for i in 0..<animationItems.count {
                let item = animationItems[i]
                performChangePositionYAndOpacityAnimation(for: item, duration: totalDuration, delay: CFTimeInterval(i % maxCountInLine) * itemDelay, fromPositionY: item.position.y, toPositionY: item.position.y + 200.0, fromOpacity: item.opacity, toOpacity: 0.0)
            }
            
        }
        
        hiddenBtn.isEnabled = (sender == showBtn)
        showBtn.isEnabled = (sender == hiddenBtn)
    }
}

//MARK: - Animation Helpers
extension ChangePositionAndOpacityDemoView {
    
    func
    performChangePositionYAndOpacityAnimation(
        for item:CALayer,
        duration:CFTimeInterval,
        delay:CFTimeInterval,
        fromPositionY:CGFloat,
        toPositionY:CGFloat,
        fromOpacity:Float,
        toOpacity:Float)
    {
        item.performChangePositionYAndOpacityAnimation(duration: duration, delay: delay, fromPositionY: fromPositionY, toPositionY: toPositionY, fromOpacity: fromOpacity, toOpacity: toOpacity)
    }
    
}
