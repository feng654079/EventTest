//
//  ImageDrawUtiles.swift
//  EventTest
//
//  Created by apple on 2021/2/19.
//  Copyright © 2021 apple. All rights reserved.
//

import Foundation

//MARK: -
extension CGImage {
    func redraw(to size:CGSize) -> CGImage? {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let width = Int(size.width)
        let height = Int(size.height)
        guard let ctx = CGContext.init(data: nil, width: width, height: height, bitsPerComponent: self.bitsPerComponent, bytesPerRow: 4 * width, space: colorSpace, bitmapInfo:self.alphaInfo.rawValue ) else {
           return nil
        }
        ctx.draw(self, in: .init(x: 0, y: 0, width: width, height: height))
        return ctx.makeImage()
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
                let cgImage = self.cgImage,
                let resultCgImage = cgImage.redraw(to: size) else {
                completion(nil)
                return
            }
            completion(UIImage(cgImage: resultCgImage))
            
        }
    }
    
    ///从bundle中加载图片,然后重绘到指定size
    static func loadImage2(name:String ,
                          fromBundle:Bundle = Bundle.main,
                          toSize:CGSize,
                          workQueue:DispatchQueue = .global(qos: DispatchQoS.QoSClass.userInteractive),
                          completion: @escaping (UIImage?) -> Void) {
        guard
            let path = fromBundle.path(forResource: name, ofType: nil)
        else {
            completion(nil)
            return
        }
        
        let fileURl = URL(fileURLWithPath: path)
        guard
            let imgData = try? Data.init(contentsOf: fileURl)
        else {
            completion(nil)
                return
        }
        
        workQueue.async {
            let resultImg = UIImage.scaledImage(with: imgData, to: toSize, scale: UIScreen.main.scale, shouldCache: true)
            DispatchQueue.main.async {
                completion(resultImg)
            }
        }
    }
    
    /**
     但处理大分辨率图片时，往往容易出现OOM，原因是-[UIImage drawInRect:]在绘制时，先解码图片，再生成原始分辨率大小的bitmap，这是很耗内存的。解决方法是使用更低层的ImageIO接口，避免中间bitmap产生
     */
    static func scaledImage(with data:Data,to size:CGSize ,scale:CGFloat,shouldCache:Bool) -> UIImage? {
        
        if size.width <= 0 || size.height <= 0 {
            return nil
        }
        
        return autoreleasepool {
            
            guard let imageSourceRef = CGImageSourceCreateWithData(data as CFData, nil) else {
                return nil
            }
            
    
            let maxPixelSize = max(size.width , size.height )
        
            let options = [
                        kCGImageSourceCreateThumbnailFromImageAlways:true,
                        kCGImageSourceThumbnailMaxPixelSize:maxPixelSize,
                        kCGImageSourceCreateThumbnailWithTransform:true ,
                        kCGImageSourceShouldCache:shouldCache] as CFDictionary
            guard
                //CGImageSourceCreateImageAtIndex方法并没有返回小图,不知道为什么╮(╯▽╰)╭
                let imageRef = CGImageSourceCreateThumbnailAtIndex(imageSourceRef, 0, options)
            else {
                return nil
            }

            return UIImage(cgImage: imageRef,scale: UIScreen.main.scale,orientation: .up)
        }
    }
}
