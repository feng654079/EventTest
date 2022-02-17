//
//  UploadAnimDemoView.swift
//  AnimationDemo
//
//  Created by apple on 2021/10/20.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit

class ShapeAndLoadAnimDemoView: UIView {

    lazy private(set) var view = UIView(frame: .zero)
    lazy private(set) var viewBorder = UIView(frame: .zero)
    lazy private(set) var circleView = CircleView(frame: .zero)
    lazy private(set) var label = UILabel(frame: .zero)
    let startBtn = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    func commonInit() {
        circleView.isHidden = true
        addSubview(circleView)
        
        view.backgroundColor = UIColor.random
        addSubview(view)
        
        viewBorder.backgroundColor = .clear
        viewBorder.layer.borderColor = UIColor.random.cgColor
        viewBorder.layer.borderWidth = 3.0
        addSubview(viewBorder)
        
        label.text = "Upload"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20.0)
        addSubview(label)
        
        startBtn.setTitle("开始", for: .normal)
        startBtn.addTarget(self, action: #selector(btnTouched(_:)), for: .touchUpInside)
        addSubview(startBtn)
    }
    
    override func layoutSubviews() {
        let containerBounds = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height * 0.7)
        
        view.frame = containerBounds
        viewBorder.frame = containerBounds
        let size = CGSize(width: 0.5 * bounds.width, height: 0.5 * bounds.height)
        circleView.frame = .init(x: (bounds.width - size.width) * 0.5, y: (bounds.height * 0.8 - size.height) * 0.5, width: size.width, height: size.height)
        label.frame = containerBounds
        
        startBtn.frame = .init(x: 0, y: 0.8 * bounds.height, width: bounds.width, height: 0.2 * bounds.height)
    }
    
    @objc func btnTouched(_ sender:UIButton) {
        startAnimation()
    }
    
    func startAnimation() {
        
        let duration = 1.0
        label.isHidden = true
    
        let animMakeBigger = CABasicAnimation(keyPath: AnimationKeyPath.cornerRadius.rawValue)
        animMakeBigger.fromValue = 5.0
        animMakeBigger.toValue = view.bounds.width * 0.8 * 0.5
        
        let animBounds = CABasicAnimation(keyPath: AnimationKeyPath.bounds.rawValue)
        animBounds.toValue = CGRect(x: 0, y: 0, width: view.bounds.width * 0.8 , height: view.bounds.width * 0.8)
        
        let animAlpha = CABasicAnimation()
        animAlpha.keyPath = AnimationKeyPath.opacity.rawValue
        animAlpha.toValue = 0
      
        let animaBackgroundColor = CABasicAnimation(keyPath: AnimationKeyPath.backgroundColor.rawValue)
        animaBackgroundColor.toValue = UIColor.green
        
        let animGroup = CAAnimationGroup()
        animGroup.duration = duration
        animGroup.isRemovedOnCompletion = false
        animGroup.fillMode = .forwards
        animGroup.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animGroup.animations = [animMakeBigger,animBounds,animAlpha,animaBackgroundColor]
        
        
        let animborder = CABasicAnimation()
        animborder.keyPath = AnimationKeyPath.borderColor.rawValue
        animborder.toValue = UIColor.red.cgColor
        
        let animGrouAll = CAAnimationGroup()
        animGrouAll.duration = duration
        animGrouAll.fillMode = .forwards
        animGrouAll.isRemovedOnCompletion = false
        animGrouAll.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animGrouAll.animations = [animMakeBigger,animBounds,animAlpha,animborder]
        animGrouAll.delegate = AnimationDelegate(didStartCallback: nil, didStopCallback: {
            [weak self]
            anim, isFinished in
            if isFinished {
                if let clv = self?.circleView {
                    clv.isHidden = false
                    clv.startDrawAnimation(didStop: {
                        [weak clv,weak self] in
                        self?.viewBorder.layer.removeAllAnimations()
                        clv?.isHidden = true
                        self?.viewBorder.layer.opacity = 1.0
                        self?.view.layer.opacity = 1.0
                        self?.viewBorder.backgroundColor = UIColor.random
                        self?.view.backgroundColor = UIColor.random
                        self?.setNeedsLayout()
                    })
                }
                
            }
        })
        
        
        view.layer.add(animGroup, forKey: nil)
        viewBorder.layer.add(animGrouAll, forKey: nil)
        
        
    }
}

//MARK: -
extension ShapeAndLoadAnimDemoView {
    
    class CircleView: UIView {
        
        lazy private(set) var circle = CAShapeLayer()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.commonInit()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            self.commonInit()
        }
        
        override func layoutSubviews() {
            circle.path = UIBezierPath.init(arcCenter: .init(x: 0.5 * bounds.width, y: 0.5 * bounds.height), radius: 0.5 * bounds.width - circle.lineWidth, startAngle: 0, endAngle: CGFloat.pi * 2.0, clockwise: true).cgPath
        }
        
        func commonInit() {
            circle.strokeColor = UIColor.blue.cgColor
            circle.fillColor = UIColor.clear.cgColor
            circle.lineCap = .round
            circle.lineJoin = .round
            circle.lineWidth = 5.0
            circle.strokeEnd = 0.0
            layer.addSublayer(circle)
        }
        
        func startDrawAnimation(didStop: (()->Void)?) {
            let animation = CABasicAnimation(keyPath: AnimationKeyPath.strokeEnd.rawValue)
            animation.duration = 3.0
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            animation.fromValue = 0.0
            animation.toValue = 1.0
            animation.delegate = AnimationDelegate(didStartCallback: nil, didStopCallback: { anim, isFinished in
                didStop?()
            })
            circle.add(animation, forKey: nil)
        }
    }

}
