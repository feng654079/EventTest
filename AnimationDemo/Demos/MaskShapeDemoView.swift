//
//  MaskShapeDemoView.swift
//  AnimationDemo
//
//  Created by apple on 2021/10/25.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit

class MaskShapeDemoView : UIView {
    
    let imageView = UIImageView()
    let maskLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    func commonInit() {
        addSubview(imageView)

        imageView.layer.mask = maskLayer
        imageView.image = UIImage(named: "avater")
        maskLayer.strokeColor = UIColor(white: 0.0, alpha: 1.0).cgColor
        maskLayer.fillColor = UIColor.clear.cgColor
        maskLayer.lineWidth = 2.0
        
    }
    
    override func layoutSubviews() {
        imageView.frame = .init(x: 0, y: 0, width: bounds.width, height: bounds.width)
        
        maskLayer.path = UIBezierPath.init(roundedRect: imageView.bounds, byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize(width: 20.0, height: 2.0)).cgPath
        
    }
}

