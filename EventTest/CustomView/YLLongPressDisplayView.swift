//
//  YLTouchDisplayView.swift
//  EventTest
//
//  Created by apple on 2020/9/14.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import UIKit

func testAtteri() -> NSAttributedString{
    let paraStyle = NSMutableParagraphStyle.init()
   
    paraStyle.alignment = .left
    paraStyle.baseWritingDirection = .rightToLeft
    
    let attri = NSAttributedString.init(string: "12345632132123", attributes: [NSAttributedString.Key.paragraphStyle : paraStyle])
    return attri
}

class TestView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    override func draw(_ rect: CGRect) {
        
        testAtteri().draw(at: .init(x: 0, y: 5))
    }
    
    func commonInit() {
        
        self.backgroundColor = .white
        
    }
}

class YLLongPressDisplayView: UIView {
    
    let hLine = CAShapeLayer()
    let vLine = CAShapeLayer()
    let hlabel = UILabel()
    let vLabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    
    func commonInit() {
        
        self.layer.addSublayer(hLine)
        self.layer.addSublayer(vLine)
        self.addSubview(hlabel)
        self.addSubview(vLabel)
        
        hLine.strokeColor = UIColor.blue.cgColor
        hLine.fillColor = UIColor.clear.cgColor
        hLine.lineCap = .round
        hLine.lineDashPattern = [5.0,5.0]
        
        vLine.strokeColor = UIColor.blue.cgColor
        vLine.fillColor = UIColor.clear.cgColor
        vLine.lineCap = .round
        vLine.lineDashPattern = [5.0,5.0]
        
        vLabel.backgroundColor = UIColor(cgColor: hLine.strokeColor!)
        hlabel.backgroundColor = UIColor(cgColor: vLine.strokeColor!)
        
        vLabel.textColor = UIColor.white
        hlabel.textColor = UIColor.white
        
        self.doHidden()
    }
    
    func doShow() {
        self.alpha = 1
    }
    
    func doHidden() {
        self.alpha = 0
    }
    func update(touchedPoint:CGPoint,price:String,date:String) {
        
        
        vLabel.text = date
        vLabel.sizeToFit()
        hlabel.text = price
        hlabel.sizeToFit()
        
        UIView.animate(withDuration: 0.1) {
            self.vLabel.center = .init(x: touchedPoint.x, y: self.bounds.height - self.vLabel.bounds.height)
            self.hlabel.center = .init(x: 0.5 * self.hlabel.bounds.width, y: touchedPoint.y)
        }
        
       
    
        _updateVerticalLine(touchedPoint: touchedPoint)
        _updateHorizontalLine(touchedPoint: touchedPoint)
    }
    
    func handleLongPressGesture(gesture:UIGestureRecognizer ,for view:UIView) {
        let loc =  gesture.location(in: view)
               
               switch gesture.state {
               
               case .possible:
                   break
               case .began:
                   self.doShow()
                   self.update(touchedPoint:loc, price: "\(loc)", date: "\(loc)")
               case .changed:
                   self.update(touchedPoint:loc, price:  "\(loc)", date: "\(loc)")
               case .ended,.cancelled,.failed:
                self.doHidden()
              
               @unknown default: break
                   
               }
    }
    
    
    //MARK:private
    func _updateVerticalLine(touchedPoint:CGPoint) {
        let path = UIBezierPath()
        path.move(to: .init(x: touchedPoint.x, y: 0))
        path.addLine(to: .init(x: touchedPoint.x, y: self.bounds.height))
        vLine.path = path.cgPath
    }
    
    func _updateHorizontalLine(touchedPoint:CGPoint) {
        let path = UIBezierPath()
        path.move(to: .init(x: 0, y: touchedPoint.y))
        path.addLine(to: .init(x: self.bounds.width, y:  touchedPoint.y))
        hLine.path = path.cgPath
    }

}
