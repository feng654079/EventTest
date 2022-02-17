//
//  ViewController.swift
//  AnimationDemo
//
//  Created by apple on 2021/10/19.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setupUI(for: ChangePositionAndOpacityDemoView.self)
        //setupUI(for: RoundFadeDemoView.self)
        //setupUI(for: LoadAnimDemoView.self)
        //setupUI(for: ShapeAndLoadAnimDemoView.self)
        
        //setupUI(for: LovingHeartAnimDemoView.self )
        //setupUI(for: CheckMarkAnimDemoView.self)
        //setupUI(for: MaskShapeDemoView.self)
        
        //setupUI(for: MaskFadeAnimationDemoView.self)
        
        //setupUI(for: ConstrantLayoutDemoView.self)
        //setupUI(for: ConstrantLayoutDemoView2.self)
        setupUI(for: WuFuAnimationDemoView.self)
        
       
        
    }
 

    func setupUI(for viewType:UIView.Type) {
        let animationV = viewType.init(frame: .zero)
        animationV.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationV)
        NSLayoutConstraint.activate([
            animationV.leftAnchor.constraint(equalTo: view.leftAnchor),
            animationV.rightAnchor.constraint(equalTo: view.rightAnchor),
            animationV.topAnchor.constraint(equalTo: view.topAnchor,constant: 80),
            animationV.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

