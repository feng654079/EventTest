//
//  ConstrantLayoutDemoView2.swift
//  AnimationDemo
//
//  Created by apple on 2021/12/29.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit

///有父view维护UI状态,并执行状态变化是的动画
///好处:动画执行效果更自由,随意实现
///坏处: 不太好维护,view有多种状态,需要有好的代码习惯
class ConstrantLayoutDemoView2:UIView {
    
    struct LayoutValues {
         let bigContrainerInsets:CGFloat = 8.0
         let bigContainerHeight:CGFloat = 50.0
         let bigContainerRadius = 8.0
         let txfInsetForBigContainer:CGFloat = 8.0
         let smallContainerInsest:CGFloat = 50.0
         let sammlContainerBorderWidth = 4.0
         let fireFoxlogoInset:CGFloat = 4.0
    }
    
    
    let bigContainer = UIView()
    let txf = UITextField()
    
    let fireFoxLogo = UIImageView()
    let smallContainer = UIView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
   
    enum UIState {
        case normal
        case searching
    }
    
    lazy private(set) var uiState:UIState = .normal
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: []) {
            self.switchUIState()
            self.layoutIfNeeded()
        } completion: { isFinished in
            
        }
        
    }
}

//MARK: -  Interface
extension ConstrantLayoutDemoView2 {
    func switchUIState() {
        switch self.uiState {
            
        case .normal:
            changeUI(to:.searching)
        case .searching:
            changeUI(to: .normal)
        }
    }
    
    func changeUI(to state:UIState) {
        let layoutValue = LayoutValues()
        switch state {
        case .normal:
            txf.snp.remakeConstraints { make in
                make.edges.equalTo(self.bigContainer).inset(layoutValue.txfInsetForBigContainer)
                make.centerY.equalTo(bigContainer)
            }
            
            bigContainer.snp.updateConstraints { make in
                make.left.right.equalToSuperview().inset(layoutValue.bigContrainerInsets)
            }
           
            bigContainer.alpha = 1.0
            smallContainer.alpha = 0.0
            fireFoxLogo.alpha = 0.0
        case .searching:

            txf.snp.remakeConstraints { make in
                make.left.equalTo(self.fireFoxLogo.snp.right).offset(layoutValue.txfInsetForBigContainer)
                make.top.right.bottom.equalTo(self.smallContainer).inset(layoutValue.txfInsetForBigContainer)
                make.centerY.equalTo(bigContainer)
            }
            bigContainer.snp.updateConstraints { make in
                make.left.right.equalToSuperview().inset(layoutValue.smallContainerInsest)
            }
            
            bigContainer.alpha = 1.0
            smallContainer.alpha = 1.0
            fireFoxLogo.alpha = 1.0
        }
        self.uiState = state
    }
}

//MARK: - Private
private extension ConstrantLayoutDemoView2 {
    func commonInit() {
        let layoutValue = LayoutValues()
        
        [bigContainer,smallContainer,txf,fireFoxLogo].forEach({
            addSubview($0)
        })
        
        bigContainer.layer.cornerRadius = layoutValue.bigContainerRadius
        bigContainer.clipsToBounds = true
        bigContainer.backgroundColor = UIColor.lightGray
        bigContainer.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(layoutValue.bigContainerHeight)
            make.left.right.equalToSuperview().inset(layoutValue.bigContrainerInsets)
        }

        txf.text = "请输入搜索内容或地址"

        smallContainer.clipsToBounds = true
        smallContainer.layer.cornerRadius = layoutValue.bigContainerRadius
        smallContainer.backgroundColor = UIColor.lightGray
        smallContainer.layer.borderWidth = layoutValue.sammlContainerBorderWidth
        smallContainer.layer.borderColor = UIColor.blue.cgColor
        smallContainer.snp.makeConstraints { make in
            make.left.equalTo(bigContainer.snp.left).offset(-layoutValue.sammlContainerBorderWidth * 0.5)
            make.right.equalTo(bigContainer.snp.right).offset(layoutValue.sammlContainerBorderWidth * 0.5)
            make.top.equalTo(bigContainer.snp.top).offset(-layoutValue.sammlContainerBorderWidth * 0.5)
            make.bottom.equalTo(bigContainer.snp.bottom).offset(layoutValue.sammlContainerBorderWidth * 0.5)
            
        }
        
        fireFoxLogo.image = UIImage(named: "splash")
        fireFoxLogo.snp.makeConstraints { make in
            make.left.top.bottom.equalTo(self.smallContainer).inset(layoutValue.fireFoxlogoInset)
            make.width.equalTo(self.fireFoxLogo.snp.height)

        }
        
        changeUI(to: .normal)
        
    }
    
    
  
}

