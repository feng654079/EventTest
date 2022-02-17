//
//  MaskFadeAnimation.swift
//  AnimationDemo
//
//  Created by apple on 2021/10/21.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit

///参考链接
///https://www.jianshu.com/p/e189696dd535

///原理: 将maskView 上的子view alpha依次设置为0

class MaskFadeAnimationDemoView: UIView {
    
    let startBtn = UIButton(type: .system)
    let imageView = UIImageView()
    let imageView1 = UIImageView()
    lazy private(set) var imageMaskView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    override func layoutSubviews() {
        imageView1.frame = .init(x: 0, y: 0, width: bounds.width, height: bounds.width)
        imageView.frame = .init(x: 0, y: 0, width: bounds.width, height: bounds.width)
        startBtn.frame = .init(x: 0, y: 0.8 * bounds.height, width: bounds.width, height: 0.2 * bounds.height)
    }
    
    func commonInit() {
        
        imageView1.image = UIImage(named: "fengjing")
        addSubview(imageView1)
        
        imageView.image = UIImage(named: "avater")
        addSubview(imageView)
        

        startBtn.setTitle("开始", for: .normal)
        startBtn.addTarget(self, action: #selector(btnTouched(_:)), for: .touchUpInside)
        addSubview(startBtn)
    }
    
    
    @objc func btnTouched(_ sender:UIButton) {
        performMaskViewItemsAnim2()
    }
}

extension MaskFadeAnimationDemoView {
    ///从上到下一行一行的动画
    func performMaskViewItemsAnim() {
        startBtn.isEnabled = false
        
        imageMaskView.backgroundColor = UIColor.clear
        imageMaskView.frame = imageView.bounds
        imageView.mask = imageMaskView
        
        let horizontatolCount = 20
        let verticalCount = 20
        let total = verticalCount * horizontatolCount
        
        func configNormalState() {
            let itemWidth = imageMaskView.bounds.width / CGFloat(horizontatolCount)
            let itemHeight = imageMaskView.bounds.height / CGFloat(verticalCount)
            for i in 0..<total {
                let item = imageMaskView.subviews[i]
                item.frame = .init(x: CGFloat(i % horizontatolCount) * itemWidth, y: CGFloat(i / horizontatolCount) * itemHeight, width: itemWidth, height: itemHeight)
                item.layer.backgroundColor = UIColor(white: 1.0, alpha:  1.0).cgColor
                item.layer.transform = CATransform3DIdentity
            }
        }
        
        if imageMaskView.subviews.count == 0 {
            for _ in 0..<total {
                imageMaskView.addSubview(UIView())
            }
            configNormalState()
        }
        
        self.imageView.mask = self.imageMaskView
        
        let duration:TimeInterval = 0.5
        let delay = 0.1
        var completionCount = 0
        for i in 0..<verticalCount {
            for j in 0..<horizontatolCount {
                let item = self.imageMaskView.subviews[i * horizontatolCount + j]
                item.layer.anchorPoint = .init(x: 0.5, y: 0.5)
                
                let rotationAnim = CABasicAnimation(keyPath: AnimationKeyPath.tranformRotationX.rawValue)
                rotationAnim.fromValue = 0
                rotationAnim.toValue = CGFloat.pi / 2.0
              
                
                let opacityAnimation = CABasicAnimation(keyPath: AnimationKeyPath.backgroundColor.rawValue)
                opacityAnimation.fromValue = UIColor(white: 1.0, alpha:  1.0).cgColor
                opacityAnimation.toValue = UIColor(white: 1.0, alpha:  0.0).cgColor
                
                let group = CAAnimationGroup()
                group.animations = [rotationAnim]
                group.duration = duration
                group.beginTime = CACurrentMediaTime() + TimeInterval(i) * delay
                group.isRemovedOnCompletion = false
                group.fillMode = .forwards
                group.delegate = AnimationDelegate(didStartCallback: nil, didStopCallback: {
                    [weak item,weak self]
                    anim,isFinished in
                    if isFinished {
                        item?.layer.backgroundColor = UIColor(white: 1.0, alpha:  0.0).cgColor
                        item?.layer.transform = CATransform3DIdentity
                        item?.layer.removeAllAnimations()
                        completionCount += 1
                        if completionCount == total {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                configNormalState()
                                self?.startBtn.isEnabled = true
                            }
                           
                        }
                    }
                })
                item.layer.add(group, forKey: nil)
            }
        }

    }
    
    //从左上角到右下角
    func performMaskViewItemsAnim2() {
        startBtn.isEnabled = false
        
        imageMaskView.backgroundColor = UIColor.clear
        imageMaskView.frame = imageView.bounds
        
        let horizontatolCount = 20
        let verticalCount = 20
        let total = verticalCount * horizontatolCount
        
        func configNormalState() {
            let itemWidth = imageMaskView.bounds.width / CGFloat(horizontatolCount)
            let itemHeight = imageMaskView.bounds.height / CGFloat(verticalCount)
            for i in 0..<total {
                let item = imageMaskView.subviews[i]
                item.frame = .init(x: CGFloat(i % horizontatolCount) * itemWidth, y: CGFloat(i / horizontatolCount) * itemHeight, width: itemWidth, height: itemHeight)
                item.layer.backgroundColor = UIColor(white: 1.0, alpha:  1.0).cgColor
                item.layer.transform = CATransform3DIdentity
            }
        }
        
        if imageMaskView.subviews.count == 0 {
            for _ in 0..<total {
                imageMaskView.addSubview(UIView())
            }
            configNormalState()
        }
        
        self.imageView.mask = self.imageMaskView
        
        ///斜行的个数
        let diagonalRowCount = horizontatolCount + verticalCount - 1
        let duration:TimeInterval = 0.5
        let delay = 0.1
        var completionCount = 0
        for sum in 0..<diagonalRowCount {
            for i in 0..<verticalCount {
                for j in 0..<horizontatolCount {
                    
                    guard i + j == sum else { continue }
                    
                    let item = self.imageMaskView.subviews[i * horizontatolCount + j]
                    
                    let rotationAnim = CABasicAnimation(keyPath: AnimationKeyPath.transform.rawValue)
                    var transform = CATransform3DMakeRotation(-CGFloat.pi / 2.0, -1.0, 1.0, 0.0)
                    transform.m34 = -1.0 / 1000.0
                    rotationAnim.toValue = transform
                    
                    let opacityAnimation = CABasicAnimation(keyPath: AnimationKeyPath.backgroundColor.rawValue)
                    opacityAnimation.fromValue = UIColor(white: 1.0, alpha:  1.0).cgColor
                    opacityAnimation.toValue = UIColor(white: 1.0, alpha:  0.0).cgColor
                    
                    let group = CAAnimationGroup()
                    group.animations = [rotationAnim]
                    group.duration = duration
                    group.beginTime = CACurrentMediaTime() + TimeInterval(sum) * delay
                    group.isRemovedOnCompletion = false
                    group.fillMode = .forwards
                    group.delegate = AnimationDelegate(didStartCallback: nil, didStopCallback: {
                        [weak item,weak self]
                        anim,isFinished in
                        if isFinished {
                            item?.layer.backgroundColor = UIColor(white: 1.0, alpha:  0.0).cgColor
                            item?.layer.transform = CATransform3DIdentity
                            item?.layer.removeAllAnimations()
                            completionCount += 1
                            if completionCount == total {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    configNormalState()
                                    self?.startBtn.isEnabled = true
                                }
                               
                            }
                        }
                    })
                    item.layer.add(group, forKey: nil)
                }
            }
        }
    }
}
