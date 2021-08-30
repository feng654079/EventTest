//
//  ImageDrawTest.swift
//  EventTest
//
//  Created by apple on 2021/2/5.
//  Copyright © 2021 apple. All rights reserved.
//

import Foundation
import CoreGraphics
import SnapKit
import CoreText

class ImageDrawViewController: UIViewController {
    
    let imageView = UIImageView()
    
    let drawGradientView = DrawGradientView()
    
    let gradientColorLabel = GradientColorLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
      
        if  let availabelFontNames = CTFontManagerCopyAvailableFontFamilyNames() as? [String] {
            let isEqualToUIFontFamilayNames = availabelFontNames == UIFont.familyNames
            debugPrint(availabelFontNames,isEqualToUIFontFamilayNames)
        }
        
         
    }
    
    func setupUI() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        drawGradientView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(drawGradientView)
        
        gradientColorLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gradientColorLabel)
        
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        drawGradientView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        drawGradientView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        drawGradientView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        drawGradientView.bottomAnchor.constraint(equalTo: imageView.topAnchor,constant: -10.0).isActive = true
        
//       gradientColorLabel
//           .widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
//        gradientColorLabel
//            .heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        gradientColorLabel.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, constant: 0.0).isActive = true
        gradientColorLabel
            .centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive  = true
        gradientColorLabel
            .topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
        
        
        
        gradientColorLabel.setLabelGradientProperty { (label, gradientLayer) in
            
            gradientLayer.colors = [
                UIColor.hexadecimalColor(hexadecimal: "ff0000").cgColor,
                UIColor.hexadecimalColor(hexadecimal: "00ff00").cgColor
            ]
            gradientLayer.anchorPoint = .zero
            gradientLayer.startPoint = .init(x: 0.0, y: 0.0)
            gradientLayer.endPoint = .init(x: 1.0, y: 1.0)
            gradientLayer.locations = [0.0,1.0]
            
            label.text = "are you ok?are you ok?are you ok?are you ok?are you ok?are you ok?are you ok?are you ok?are you ok?are you ok?are you ok?are you ok?are you ok?are you ok?are you ok?"
            label.numberOfLines = 0
            label.font = UIFont.systemFont(ofSize: 40.0)
        }
        
        

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        testOriginImage()
        
    
        ///修改只需要重新调用即可
        gradientColorLabel.setLabelGradientProperty { (label, _) in
            label.text = "123456"
        }
    }
}


//MARK: -
extension ImageDrawViewController {
    func testOriginImage() {
        
//        UIImage.loadImage(name: "bigImage.png", toSize:.init(width: 100.0, height: 100.0)) {
//            [weak self]( image) in
//            self?.imageView.image = image
//        }
        
        
//        UIImage.loadImage2(name: "bigImage.png", toSize: .init(width: 100.0, height: 100.0)) { [weak self] (image) in
//            self?.imageView.image = image
//        }
        
     

//        if
//            let path = Bundle.main.path(forResource: "bigImage.png", ofType: nil)
//           {
//            let fileURL = URL(fileURLWithPath: path)
//            self.imageView.sd_setImage(with: fileURL)
//
//        }
        
        //KeyValue.testKeyValue()
        
        AlamofireTest().testUpload()
    }
    
}


//MARK: -
extension UIColor{
    
    /// 使用hex形式创建color
    /// - Parameter hexadecimal:rbg格式   e.g #252525 ,0x252525,252525
    /// - Returns: 返回颜色
    class func hexadecimalColor(hexadecimal:String,alpha:CGFloat = 1.0) -> UIColor {
        var colorStr = hexadecimal.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        if colorStr.hasPrefix("#") {
            colorStr = String(colorStr.dropFirst())
        }
        if colorStr.hasPrefix("0X") {
            colorStr = String(colorStr.dropFirst(2))
        }
        var components = [UInt32]()
        var index = 0
        while index < colorStr.count {
            if
                let start = colorStr.index(colorStr.startIndex, offsetBy: index,limitedBy: colorStr.endIndex),
                let end = colorStr.index(start,offsetBy: 2,limitedBy: colorStr.endIndex)
            {
                let com = colorStr[start..<end]
                let scanner = Scanner.init(string: String(com))
                var value:UInt32 = 0x0
                if scanner.scanHexInt32(&value) {
                    components.append(value)
                }
            }
            index += 2
        }
        guard components.count == 3 else { return .clear }
        return UIColor(red: CGFloat(components[0]) / 255.0, green: CGFloat(components[1]) / 255.0, blue: CGFloat(components[2]) / 255.0, alpha: alpha)
    }
}

class DrawGradientView: UIView  {
    
    override func draw(_ rect: CGRect) {
        test2(rect)
    }
    
    func test2(_ rect: CGRect) {
        let locations:[CGFloat] = [0.0,1.0]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        if let gradient = CGGradient(colorsSpace: colorSpace, colors: [
            UIColor.hexadecimalColor(hexadecimal: "#ff0000").cgColor,
            UIColor.hexadecimalColor(hexadecimal: "#00ff00").cgColor
        ] as CFArray, locations: locations)
        {
            let ctx = UIGraphicsGetCurrentContext()
            ctx?.drawLinearGradient(gradient, start: .zero, end: .init(x:0, y: rect.size.height), options: .drawsAfterEndLocation)
        }
    }
    
    
    func test1(_ rect: CGRect) {
        
        let ctx = UIGraphicsGetCurrentContext()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        //red
        var components1:[CGFloat] = [1.0,0.0,0.0,1.0]
        let cgColor1 = CGColor.init(colorSpace: colorSpace, components: &components1)
        
        //green
        var components2:[CGFloat] = [0.0,1.0,0.5,1.0]
        let cgColor2 = CGColor.init(colorSpace: colorSpace, components: &components2)
        
        var locations:[CGFloat] = [0.0,1.0]
        
        if let gradient = CGGradient.init(colorsSpace: colorSpace, colors: [cgColor1,cgColor2] as CFArray, locations: &locations) {
            ctx?.drawLinearGradient(gradient, start: .zero, end: .init(x:0, y: rect.size.height), options: .drawsAfterEndLocation)
        }
    }
    
    
}

//MARK:- 可以显示梯度颜色的Label

class GradientColorLabel: UIView {
    
    let label = UILabel()
    let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commomInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        debugPrint(#function,frame)
        label.frame = self.bounds
        gradientLayer.frame = self.bounds
        invalidateIntrinsicContentSize()
    }
    
    func commomInit() {
        layer.addSublayer(gradientLayer)
   
        gradientLayer.mask = label.layer
    }
    
    /// auto layout
    override var intrinsicContentSize: CGSize {
        return label.sizeThatFits(.init(width: bounds.width, height: CGFloat.greatestFiniteMagnitude))
    }
    
    
    ///配置属性的方法
    func setLabelGradientProperty(_ setter:(UILabel,CAGradientLayer) -> Void) {
        setter(label,gradientLayer)
        invalidateIntrinsicContentSize()
    }
    
}
