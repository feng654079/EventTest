//
//  ImageDrawTest.swift
//  EventTest
//
//  Created by apple on 2021/2/5.
//  Copyright © 2021 apple. All rights reserved.
//

import Foundation
import CoreGraphics

class ImageDrawViewController: UIViewController {
    
    let imageView = UIImageView()
    
    let drawGradientView = DrawGradientView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
      
    }
    
    func setupUI() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        drawGradientView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(drawGradientView)
        
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        drawGradientView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        drawGradientView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        drawGradientView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        drawGradientView.bottomAnchor.constraint(equalTo: imageView.topAnchor,constant: -10.0).isActive = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        testOriginImage()
    }
}

//MARK: -
extension UIImage {
    ///从bundle中加载图片
    static func image(name:String ,fromBundle:Bundle = Bundle.main) -> UIImage? {
        guard
            let path = fromBundle.path(forResource: name, ofType: nil) else {
            return nil
        }
        return UIImage(contentsOfFile: path)
    }
    
    ///从bundle中加载图片,然后重绘到指定size
    static func loadImage(name:String ,
                          fromBundle:Bundle = Bundle.main,
                          toSize:CGSize,
                          completion: @escaping (UIImage?) -> Void) {
        let img = image(name: name, fromBundle: fromBundle)
        img?.redraw2(to: toSize, completion: { (result) in
            DispatchQueue.main.async {
                completion(result)
            }
        })
    }
    
    ///重绘到指定Size
    func redraw(in queue:DispatchQueue = DispatchQueue.global(qos: .userInteractive),
                to size:CGSize,
                completion:@escaping (UIImage?) -> Void) {
        queue.async {
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            self.draw(in: .init(x: 0, y: 0, width: size.width, height: size.height))
            let img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            completion(img)
        }
    }
    
    ///重绘到指定Size
    func redraw2(in queue:DispatchQueue = DispatchQueue.global(qos: .userInitiated),
                 to size:CGSize,
                 completion:@escaping (UIImage?) -> Void) {
        queue.async {
            guard size != .zero,
                  let cgImage = self.cgImage else {
                completion(nil)
                return
            }
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let width = Int(size.width)
            let height = Int(size.height)
            guard let ctx = CGContext.init(data: nil, width: width, height: height, bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 4 * width, space: colorSpace, bitmapInfo:cgImage.alphaInfo.rawValue ) else {
                completion(nil)
                return
            }
            ctx.draw(cgImage, in: .init(x: 0, y: 0, width: width, height: height))
            if let resultCGImage = ctx.makeImage() {
                completion(UIImage(cgImage: resultCGImage))
            } else {
                completion(nil)
            }
            
            
        }
    }
}
//MARK: -
extension ImageDrawViewController {
    func testOriginImage() {
        // self.imageView.image = UIImage.image(name: "bigImage.png")
        
        UIImage.loadImage(name: "bigImage.png", toSize:.init(width: 100.0, height: 100.0)) {
            [weak self]( image) in
            self?.imageView.image = image
        }
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
