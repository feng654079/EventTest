//
//  MaskAnimDemoView.swift
//  AnimationDemo
//
//  Created by apple on 2021/10/21.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit

///爱心绘制动画
class LovingHeartAnimDemoView : UIView {
    
    let bgView = UIImageView()
    let shapeLayer = CAShapeLayer()
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
        
        bgView.frame = .init(x: 0, y: 0.8 * bounds.height * 0.5 - radius , width: radius * 2.0, height: radius * 2.0)
        bgView.layer.cornerRadius = radius
        
        let path = UIBezierPath(arcCenter: .init(x: 0.5 * bounds.width , y: 0.8 * bounds.height * 0.5), radius:radius * 0.501, startAngle: -CGFloat.pi / 2.0, endAngle: 2.0 * CGFloat.pi, clockwise: true)
        shapeLayer.lineWidth = radius
        shapeLayer.path = path.cgPath
        layer.addSublayer(shapeLayer)
        
        startBtn.frame = .init(x: 0, y: 0.8 * bounds.height, width: bounds.width, height: 0.2 * bounds.height)
    }
    
    func commonInit() {
        //bgView.image = UIImage(named: "avater")
        bgView.image = UIImage(named: "aixin")
        bgView.backgroundColor = UIColor.white
        bgView.clipsToBounds = true
        addSubview(bgView)
        
        shapeLayer.strokeColor = bgView.backgroundColor?.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.backgroundColor = UIColor.red.cgColor
        layer.addSublayer(shapeLayer)
        
        startBtn.setTitle("开始", for: .normal)
        startBtn.addTarget(self, action: #selector(btnTouched(_:)), for: .touchUpInside)
        addSubview(startBtn)
    }
    
    
    @objc func btnTouched(_ sender:UIButton) {
        startBtn.isEnabled = false
        let storkeAnmi = CABasicAnimation(keyPath: AnimationKeyPath.strokeEnd.rawValue)
        storkeAnmi.fromValue = 1.0
        storkeAnmi.toValue = 0.0
        storkeAnmi.duration = 4.0
        storkeAnmi.repeatCount = 20.0
        storkeAnmi.delegate = AnimationDelegate(didStartCallback: nil, didStopCallback: {
            [weak self] anim, isFinished in
            if isFinished {
                self?.startBtn.isEnabled = true
            }
        })
        shapeLayer.add(storkeAnmi, forKey: nil)
    }
}
