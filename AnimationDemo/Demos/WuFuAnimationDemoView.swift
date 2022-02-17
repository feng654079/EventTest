//
//  WuFuAnimationDemoView.swift
//  AnimationDemo
//
//  Created by apple on 2022/2/7.
//  Copyright © 2022 apple. All rights reserved.
//

import UIKit

//MARK: - Define
class WuFuAnimationDemoView:UIView {
    
    let wufuCardView: UIImageView = {
        let result = UIImageView()
        result.image = UIImage(named: "fu")
        result.contentMode = .scaleAspectFit
        return result
    }()
    
    let haloView: UIImageView = {
        let result = UIImageView()
        result.image = UIImage(named: "halo")
        result.contentMode = .scaleAspectFit
        return result
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    func commonInit() {
        
        addSubview(haloView)
        haloView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.edges.equalToSuperview().inset(30.0)
        }
        haloView.isHidden = true
        
        addSubview(wufuCardView)
        wufuCardView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.edges.equalToSuperview().inset(30.0)
            
        }
        wufuCardView.isHidden = true
        
    }
}

//MARK: - SubTypes
extension WuFuAnimationDemoView {
    fileprivate struct AnimationParameters {
        let cardDuration:TimeInterval = 3.25
        let cardStartZ:CGFloat = -20000
        let haloDuration:TimeInterval = 3.2
        let haloRotateDuration:TimeInterval = 12.0
    }
}

//MARK: - Override
extension WuFuAnimationDemoView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.performFuCardAnimation()
        self.performHaloAnimation()
    }
}


//MARK: - Interface
extension WuFuAnimationDemoView {}

//MARK: - Private
private extension WuFuAnimationDemoView {
    
    func performFuCardAnimation() {
        self.wufuCardView.isHidden = true
        // 福卡动画是 z轴平移 加 y轴旋转
        // 通过transforms实现
        
        let animKey = "wufu.card"
        let animPara = AnimationParameters()
        
        let trasnformAnimation = CABasicAnimation.init(keyPath: AnimationKeyPath.transform.rawValue)
        trasnformAnimation.duration = animPara.cardDuration
        
        var fromTransform = CATransform3DIdentity
        fromTransform.m34 = -1.0 / 900.0
        fromTransform = CATransform3DTranslate(fromTransform, 0, 0, animPara.cardStartZ)
        fromTransform = CATransform3DRotate(fromTransform, CGFloat.pi, 0.0, 1.0, 0.0)
        
        trasnformAnimation.fromValue = fromTransform
        trasnformAnimation.toValue = CATransform3DMakeTranslation(0, 0, 0)
        
        let animationDelegate =  AnimationDelegate.init { [weak self] anim in
            self?.wufuCardView.isHidden = false
        } didStopCallback: { [weak self] anim, isFinished in
            if isFinished {
                self?.wufuCardView.layer.removeAnimation(forKey: animKey)
            }
        }
        trasnformAnimation.delegate = animationDelegate
        trasnformAnimation.timingFunction = CAMediaTimingFunction.init(name: .easeInEaseOut)
        trasnformAnimation.fillMode = .forwards
        trasnformAnimation.isRemovedOnCompletion = false
        wufuCardView.layer.add(trasnformAnimation, forKey: animKey)
        
    }
    
    //光晕动画
    func performHaloAnimation() {
        
        let animkey = "wufu.halo"
        self.haloView.isHidden = true
      
        let animPara = AnimationParameters()
        
        haloView.layer.zPosition = animPara.cardStartZ > 0 ? animPara.cardStartZ + 1 : animPara.cardStartZ  - 1
        
        let scaleAnim = CABasicAnimation.init(keyPath: AnimationKeyPath.transform.rawValue)
        
        let startTramsform = CATransform3DMakeScale(0, 0, 0)
        let endTransform = CATransform3DMakeScale(4.5, 4.5, 0)
        
        scaleAnim.fromValue = startTramsform
        scaleAnim.toValue = endTransform
        scaleAnim.duration = animPara.haloDuration
        
        let animationDelegate =  AnimationDelegate.init { [weak self] anim in
            self?.haloView.isHidden = false
        } didStopCallback: { [weak self] anim, isFinished in
            self?.performHaloRotationAnimation()
        }
        scaleAnim.delegate = animationDelegate
        scaleAnim.fillMode = .forwards
        scaleAnim.isRemovedOnCompletion = false
        haloView.layer.add(scaleAnim, forKey: animkey)
        
    }
    
    
    //光晕旋转动画
    func performHaloRotationAnimation() {
        //let aniKey = "wufu.halo.rotate"
        let animPara = AnimationParameters()
        let rotationAnimation = CABasicAnimation.init(keyPath: AnimationKeyPath.tranformRotationZ.rawValue)
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = 2.0 * CGFloat.pi
        rotationAnimation.duration = animPara.haloRotateDuration
        rotationAnimation.repeatCount = Float.greatestFiniteMagnitude
        haloView.layer.add(rotationAnimation, forKey: nil)
    }
}
