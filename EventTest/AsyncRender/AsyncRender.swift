//
//  AsyncRender.swift
//  EventTest
//
//  Created by apple on 2021/1/13.
//  Copyright © 2021 apple. All rights reserved.
//

import Foundation
import UIKit

class AsyncRenderViewController: UIViewController {
    
    let asyncRenderView = AsyncRenderView(frame: .zero)
    var widthCons: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    func setupUI() {
        //asyncRenderView.backgroundColor = .red
        //asyncRenderView.frame = .init(x: (self.view.bounds.width - 100.0) * 0.5, y: (self.view.bounds.height - 100.0) * 0.5, width: 100, height: 100)
        asyncRenderView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(asyncRenderView)
        asyncRenderView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        asyncRenderView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        asyncRenderView.heightAnchor.constraint(equalTo: asyncRenderView.widthAnchor).isActive = true
        let widthCons = asyncRenderView.widthAnchor.constraint(equalToConstant: 100)
        widthCons.isActive = true
        self.widthCons = widthCons
        
    
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //let s = asyncRenderView.bounds.width * 1.05
        //asyncRenderView.frame = .init(x: (self.view.bounds.width - s) * 0.5, y: (self.view.bounds.height - s) * 0.5, width: s, height: s)
        if let c = widthCons {
            c.constant = c.constant * 1.05
        }
        UIApplication.shared.openURL(URL(string: "dfqywx.ifeng-tech.com://")!)
    }
}

//MARK: -
class AsyncRenderView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        //addObserverForMainRunloop()
        self.layer.setNeedsDisplay()
    }


    func addObserverForMainRunloop()  {
     
        let rlob = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, CFRunLoopActivity.beforeWaiting.rawValue, true, 0) { (ob, activity) in
            debugPrint("rlob:\(activity)")
            self.layer.setNeedsDisplay()
        }
        
        let mainRl = CFRunLoopGetMain()
        CFRunLoopAddObserver(mainRl, rlob, CFRunLoopMode.commonModes)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func layoutSubviews() {
        debugPrint(#function)
        self.layer.setNeedsDisplay()
    }

    override func display(_ layer: CALayer) {
        debugPrint(#function)
        DispatchQueue.global().async {
            var size:CGSize = .zero
            DispatchQueue.main.sync {
                size = self.bounds.size
            }
            let context = CGContext.beginCurrentUIGraphicsImageContextWithOptions(size, false, 0.0)
            context?.initial(for: size)
            
            ///绘制红色边框
            context?.performIndependentDraw {
                context?.setStrokeColor(UIColor.red.cgColor)
                context?.setLineWidth(10.0)
                context?.stroke(.init(x: 0, y: 0, width: size.width, height: size.height))
                
            }
            
            ///绘制绿色背景
            context?.performIndependentDraw {
                context?.setFillColor(UIColor.green.cgColor)
                context?.fill(.init(x: 5.0, y: 5.0, width: size.width - 10.0, height: size.height - 10.0))
            }
            
          ///绘制蓝色的斜线  /
            context?.performIndependentDraw {
                context?.setStrokeColor(UIColor.blue.cgColor)
                context?.setLineWidth(5.0)
                context?.move(to:  .init(x: 0, y: 0))
                context?.addLine(to:.init(x: size.width ,y: size.height))
                context?.strokePath()
            }
            
            
            let content = UIGraphicsGetImageFromCurrentImageContext()
            DispatchQueue.main.async {
                self.layer.contents = content?.cgImage
                UIGraphicsEndImageContext()
            }
        }
        
    }
  
}

extension CGContext {
    
    static func
    beginCurrentUIGraphicsImageContextWithOptions
    (_ size:CGSize,_ opaque: Bool ,_ scale:CGFloat)
    -> CGContext? {
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        return UIGraphicsGetCurrentContext()
    }
    
    /// 针对UIView绘制进行初始化,执行坐标系的转换
    /// - Parameter viewSize: view 的大小
    func initial(for viewSize:CGSize) {
        self.translateBy(x: 0, y: viewSize.height)
        self.scaleBy(x: 1.0, y: -1.0)
    }
    

    /// 执行独立的绘制,block在saveGState 和 restoreGState之前执行
    /// - Parameter block: 绘制函数
    func performIndependentDraw(block: ()->Void ) {
        self.saveGState()
        block()
        self.restoreGState()
    }
}
