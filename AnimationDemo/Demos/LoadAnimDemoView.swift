//
//  LoadAnimDemoView.swift
//  AnimationDemo
//
//  Created by apple on 2021/10/20.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit

class LoadAnimDemoView: UIView {
    
    let startBtn = UIButton(type: .system)
    lazy private(set) var animationItems = [CALayer]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    override func layoutSubviews() {
        startBtn.frame = .init(x: 0, y: 0.8 * bounds.height, width: bounds.width, height: 0.2 * bounds.height)
        
        let numOfItems = animationItems.count
        let maxCountInLine = min(numOfItems, 6)
        let scale = 1.0 / CGFloat(maxCountInLine + 2)
        let itemSize = CGSize(width:scale * bounds.width, height: scale * bounds.width)
        let spacing = (bounds.width - CGFloat(maxCountInLine) * itemSize.width) / CGFloat(maxCountInLine + 1)
        for i in 0..<numOfItems {
            animationItems[i].position = CGPoint(x: spacing + CGFloat(i % maxCountInLine) * (spacing + itemSize.width) + itemSize.width * 0.5, y: itemSize.height + CGFloat(i / maxCountInLine) * (spacing + itemSize.height) + itemSize.height * 0.5)
            animationItems[i].bounds = .init(origin: .zero, size: itemSize)
            animationItems[i].cornerRadius = itemSize.height * 0.5
            animationItems[i].masksToBounds = true
        }
        
    }
    
    func commonInit() {
        startBtn.setTitle("开始", for: .normal)
        startBtn.addTarget(self, action: #selector(btnTouched(_:)), for: .touchUpInside)
        addSubview(startBtn)
        let numOfItems = 3
        for _ in 0..<numOfItems {
            let layerItem = CALayer()
            layerItem.backgroundColor = UIColor.random.cgColor
            layer.addSublayer(layerItem)
            animationItems.append(layerItem)
        }
    }
    
    @objc func btnTouched(_ sender:UIButton) {
        guard
            animationItems.count == 3
        else { return }
        
        
        let leftMovePath = getLeftItemMovePath(leftPosition: animationItems[0].position, middlePosition: animationItems[1].position, rightPosition: animationItems[2].position, radius: (animationItems[1].position.x - animationItems[0].position.x) * 0.5)
        
        let middleMovePath = getMiddelItemMovePath(middlePosition: animationItems[1].position, leftPosition: animationItems[0].position, radius: (animationItems[1].position.x - animationItems[0].position.x) * 0.5)
        
        let rightMovePath = getRightItemPath(rightPosition: animationItems[2].position, middlePosition: animationItems[1].position, radius: (animationItems[2].position.x - animationItems[1].position.x) * 0.5)
        
        let animationKey = "load.anmi"
        let duartion = 1.5
        let repeatCount = Float.greatestFiniteMagnitude
        
        animationItems[0]
            .performPathAnimation(
                for: animationKey, duration: duartion, delay: 0.0,
                   path: leftMovePath,
                   toPosition: animationItems[2].position,
                   fromColor: animationItems[0].backgroundColor ?? UIColor.darkGray.cgColor,
                   toColor: animationItems[2].backgroundColor ?? UIColor.darkGray.cgColor,
                   repeatCount: repeatCount,animationDelegate: AnimationDelegate(didStartCallback: nil, didStopCallback: {
                       [weak self]
                       anim, isFinished in
                       if isFinished {
                           self?.animationItems[0].removeAnimation(forKey: animationKey)
                       }
                   }))
        
        animationItems[1]
            .performPathAnimation(
                for: animationKey, duration: duartion, delay: 0.0,
                   path: middleMovePath,
                   toPosition: animationItems[0].position,
                   fromColor: animationItems[2].backgroundColor ?? UIColor.darkGray.cgColor,
                   toColor: animationItems[0].backgroundColor ?? UIColor.darkGray.cgColor,
                   repeatCount:repeatCount)
        
        animationItems[2]
            .performPathAnimation(
                for: animationKey, duration: duartion, delay: 0.0,
                   path: rightMovePath,
                   toPosition: animationItems[1].position,
                   fromColor: animationItems[0].backgroundColor ?? UIColor.darkGray.cgColor,
                   toColor: animationItems[1].backgroundColor ?? UIColor.darkGray.cgColor,
            repeatCount: repeatCount)
       
        
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + duartion + 0.05) {
//            [self] in
//            let first = animationItems[0]
//            animationItems.removeFirst()
//            animationItems.append(first)
//            btnTouched(startBtn)
//        }
    }
}
//MARK: - animation helpers
private extension LoadAnimDemoView {
    func getLeftItemMovePath(
        leftPosition:CGPoint,
        middlePosition:CGPoint,
        rightPosition:CGPoint,
        radius:CGFloat
    )
    -> UIBezierPath
    {
        let leftPath = UIBezierPath.init(
            arcCenter:CGPoint(x: (leftPosition.x + middlePosition.x) * 0.5, y: (leftPosition.y + middlePosition.y) * 0.5),
            radius: radius,
            startAngle: CGFloat.pi,
            endAngle: 2 * CGFloat.pi,
            clockwise: true)
        let rightPath = UIBezierPath.init(
            arcCenter:CGPoint(x: (rightPosition.x + middlePosition.x) * 0.5, y: (rightPosition.y + middlePosition.y) * 0.5),
            radius: radius,
            startAngle: CGFloat.pi,
            endAngle: 0,
            clockwise: false)
        leftPath.append(rightPath)
        return leftPath
        
    }
    
    func getMiddelItemMovePath(
        middlePosition:CGPoint,
        leftPosition:CGPoint,
        radius:CGFloat
    ) -> UIBezierPath {
        return UIBezierPath.init(
            arcCenter:CGPoint(x: (leftPosition.x + middlePosition.x) * 0.5, y: (leftPosition.y + middlePosition.y) * 0.5),
            radius: radius,
            startAngle: 0,
            endAngle: CGFloat.pi,
            clockwise: true)
    }
    
    func getRightItemPath(rightPosition:CGPoint,middlePosition:CGPoint,radius:CGFloat) -> UIBezierPath {
        return UIBezierPath.init(
            arcCenter:CGPoint(x: (rightPosition.x + middlePosition.x) * 0.5, y: (rightPosition.y + middlePosition.y) * 0.5),
            radius: radius,
            startAngle: 0,
            endAngle: CGFloat.pi,
            clockwise: false)
    }
}
