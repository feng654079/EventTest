//
//  ImageDrawTest.swift
//  EventTest
//
//  Created by apple on 2021/2/5.
//  Copyright © 2021 apple. All rights reserved.
//

import Foundation


class ImageDrawViewController: UIViewController {
    
    let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        testOriginImage()
    }
    
    func setupUI() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
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
        img?.redraw(to: toSize, completion: { (result) in
            DispatchQueue.main.async {
                completion(img)
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
    
    
}
//MARK: -
extension ImageDrawViewController {
    func testOriginImage() {
       // self.imageView.image = UIImage.image(name: "bigImage.png")
        
        UIImage.loadImage(name: "bigImage.png", toSize: .init(width: 100.0, height: 100.0)) {
            [weak self]( image) in
            self?.imageView.image = image
        }
    }
}
