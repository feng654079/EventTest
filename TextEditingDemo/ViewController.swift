//
//  ViewController.swift
//  TextEditingDemo
//
//  Created by apple on 2021/10/15.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit
import YYKit
import SDWebImage

class ViewController: UIViewController {
    lazy private(set) var textView = YYTextView.init(frame: .zero)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //setupUI()
        //setTextViewContent()
     
        setupImageView()
    
    }


}

//MARK: - UI

extension ViewController {
    func setupUI() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.leftAnchor.constraint(equalTo: view.leftAnchor),
            textView.rightAnchor.constraint(equalTo: view.rightAnchor),
            textView.topAnchor.constraint(equalTo: view.topAnchor,constant: 80.0),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setTextViewContent() {
        let content = NSMutableAttributedString()
        let font = UIFont.systemFont(ofSize: 30.0)
        let text = NSMutableAttributedString.init(string: "这个是文字", attributes: [
            .font: font,
            .foregroundColor: UIColor.black
        ])
        content.append(text)
        
        do {
            let textField = UITextField()
            textField.backgroundColor = UIColor.green
            textField.placeholder = "xxx"
            textField.frame = .init(x: 0, y: 0, width: 40, height: 80.0)
            let textFieldAttribte = NSAttributedString
                .attachmentString(
                    withContent: textField,
                    contentMode: .center,
                    attachmentSize: textField.frame.size,
                    alignTo: font,
                    alignment: .center)
            content.append(textFieldAttribte)
        }
        
        do {
            let aView = UIView()
            aView.frame = .init(x: 0, y: 0, width: 400, height: 50)
            aView.backgroundColor = UIColor.red
            //指定contentmode为非充满的选项时要注意设置大小
            let viewAttriStr = NSAttributedString
                .attachmentString(
                    withContent: aView,
                    contentMode: .center,
                    attachmentSize: .init(width: aView.frame.width + 20.0, height: aView.frame.height + 50.0),
                    alignTo: font,
                    alignment: .center)
            content.append(viewAttriStr)
        }
        
        do {
            let switcher = UISwitch()
            switcher.sizeToFit()
            let switcherStr = NSAttributedString.attachmentString(withContent: switcher, contentMode: .center, attachmentSize: switcher.size, alignTo: font, alignment: .center)
            content.append(switcherStr)
        }
        
        content.append(text)
       
        textView.attributedText = content
    
        
    }
    
   
    @objc func injected() {
      #if DEBUG
        debugPrint("injected")
        viewDidLoad()
      #endif
    }
   
}


//MARK: -
extension ViewController {
    
    func setupImageView() {
        
        
        let imageView = UIImageView(frame: .init(x: 50, y: 50, width: 100, height: 100))
        view.addSubview(imageView)
        
        ///原图解码后占用16M左右
        guard
            let imgUrl = URL(string: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg2.niutuku.com%2Fdesk%2F1207%2F0944%2Fntk111703.jpg&refer=http%3A%2F%2Fimg2.niutuku.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1639018104&t=184642e51d9fcd49a79712074838b1b5")
        else { return }
        
        //设置图片解码大小,节省内存
        let context:[SDWebImageContextOption:Any] = [SDWebImageContextOption.imageThumbnailPixelSize: CGSize(width: 50, height: 50)]
        
        imageView.sd_setImage(with: imgUrl, placeholderImage: nil, options: [], context: context )
        
        
    }
}

