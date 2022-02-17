//
//  CheckMarkAnimDemoView.swift
//  AnimationDemo
//
//  Created by apple on 2021/10/21.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit

///对钩绘制动画
class CheckMarkAnimDemoView : UIView {
    
    let bgView = UIImageView()
    let animMask = CALayer()
    let startBtn = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    override func layoutSubviews() {
        let radius = 0.5 * bounds.width
        let centerY = 0.8 * bounds.height * 0.5
        bgView.frame = .init(x: 0, y: centerY - radius , width: radius * 2.0, height: radius * 2.0)
        bgView.layer.cornerRadius = radius
        
        animMask.anchorPoint = .zero
        animMask.frame = bgView.frame
      
        
        startBtn.frame = .init(x: 0, y: 0.8 * bounds.height, width: bounds.width, height: 0.2 * bounds.height)
    }
    
    func commonInit() {
        bgView.image = UIImage(named: "duihao-2")
        bgView.backgroundColor = UIColor.white
        addSubview(bgView)
        
        animMask.backgroundColor = bgView.backgroundColor?.cgColor
        layer.addSublayer(animMask)
       
        startBtn.setTitle("开始", for: .normal)
        startBtn.addTarget(self, action: #selector(btnTouched(_:)), for: .touchUpInside)
        addSubview(startBtn)
    }
    
    
    @objc func btnTouched(_ sender:UIButton) {
        startBtn.isEnabled = false
        
        let storkeAnmi = CABasicAnimation(keyPath: AnimationKeyPath.positionX.rawValue)
        storkeAnmi.fromValue = 0.0
        storkeAnmi.toValue = animMask.bounds.width
        storkeAnmi.duration = 1.0
        storkeAnmi.repeatCount = 5
        storkeAnmi.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        storkeAnmi.delegate = AnimationDelegate(didStartCallback: nil, didStopCallback: {
            [weak self] anim, isFinished in
            if isFinished {
                self?.startBtn.isEnabled = true
            }
        })
        animMask.add(storkeAnmi, forKey: nil)
    }
}
