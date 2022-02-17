//
//  ConstrantLayoutDemoView.swift
//  AnimationDemo
//
//  Created by apple on 2021/12/29.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit
import SnapKit

class AddressAndBtnsView:UIView {
    
    let lockImg = UIImageView()
    let displayText = UITextField()
    let refreshBtn = UIButton()
    let line = UIView()
    let moreBtn = UIButton()
    
    private(set) var stackView:UIStackView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    func commonInit() {
        backgroundColor = UIColor.lightGray
        layer.cornerRadius = 8.0
        clipsToBounds = true
        
//        stackView = UIStackView(arrangedSubviews:
//          [lockImg,displayText,refreshBtn,line,moreBtn]
//        )
        stackView = UIStackView(arrangedSubviews:
          [displayText]
        )
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 2.0
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(8.0)
        }
      
        lockImg.image = UIImage(named: "lock_verified")
        refreshBtn.setImage(UIImage(named: "bookmarkFolder"), for: .normal)
        moreBtn.setImage(UIImage(named: "bookmarkFolder"), for: .normal)
        
        line.backgroundColor = UIColor.black
        line.layer.cornerRadius = 2.0
        line.snp.makeConstraints { make in
            make.width.equalTo(2.0)
            make.height.equalTo(26.0)
        }
        
        setDislayTxt("请输入搜索内容或地址")
        
//        [lockImg,refreshBtn,moreBtn]
//            .forEach({
//                $0.snp.makeConstraints { make in
//                    make.size.equalTo(CGSize(width: 30, height: 30))
//                }
//            })
    }
    
    
    func setDislayTxt(_ txt:String) {
        displayText.text = txt
    }
}

//MARK: -

class SearchInputView:UIView {
    
    let txtInput = UITextField()
    let iconImg = UIImageView()
    
    private(set) var stack:UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    func commonInit() {
        
        layer.cornerRadius = 8.0
        layer.borderWidth = 4.0
        layer.borderColor = UIColor.blue.cgColor
        backgroundColor = .lightGray
        
        stack = UIStackView(arrangedSubviews: [iconImg,txtInput])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 2.0
        addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(8.0)
        }
        
        iconImg.image = UIImage(named: "splash")
        iconImg.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        
        setDislayTxt("请输入搜索内容或地址")
        
    }
    
    func setDislayTxt(_ txt:String) {
        txtInput.text = txt
    }
}


//MARK: -
///将动画的不同状态封装成不同的view,然后执行过度动画
///好处:view好维护,每个view只显示一种状态
///坏处: 添加了额外的视图,固定了视图层级,有些动画效果不太好实现,
class ConstrantLayoutDemoView:UIView {
    
    let urlDisplayView = AddressAndBtnsView()
    
    lazy private(set)
    var urlInputView:SearchInputView = {
        let r = SearchInputView()
        insertSubview(r, belowSubview: urlDisplayView)
        r.snp.makeConstraints { make in
            make.centerY.equalTo(self.urlDisplayView.snp.centerY)
            make.height.equalTo(self.urlDisplayView).offset(6.0)
            make.right.equalTo(self.urlDisplayView.snp.right)
            make.left.equalTo(self.urlDisplayView.snp.left)
        }
        return r
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
        
        addSubview(urlDisplayView)
        urlDisplayView.backgroundColor = UIColor.lightGray
        urlDisplayView.clipsToBounds = true
        urlDisplayView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20.0)
            make.top.equalToSuperview().offset(50)
            make.height.equalTo(50)
        }
        
        self.urlInputView.alpha = 0.0
     
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.80, initialSpringVelocity: 0.0, options: []) {
            self.performAnimation(
                toSearch: (self.urlDisplayView.alpha > 0))
        } completion: { _ in

        }
    }

    
    func performAnimation(toSearch:Bool) {
    
        if toSearch {
            self.urlDisplayView.alpha = 0.0
            self.urlDisplayView.snp.updateConstraints { make in
                make.left.right.equalToSuperview().inset(80.0)
            }
            self.urlInputView.alpha = 1.0
            self.layoutIfNeeded()
        } else {
            self.urlDisplayView.alpha = 1.0
            self.urlInputView.alpha = 0.0
            self.urlDisplayView.snp.updateConstraints { make in
                make.left.right.equalToSuperview().inset(20.0)
            }
            self.layoutIfNeeded()
        }
    }
    
}
