//
//  DissVC.swift
//  EventTest
//
//  Created by apple on 2021/1/4.
//  Copyright © 2021 apple. All rights reserved.
//

import Foundation

class DissVC: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.view.backgroundColor = .lightGray
        
        let btn = UIButton()
        btn.setTitle("dismiss", for: .normal)
        btn.addTarget(self, action: #selector(dismissTouched), for: .touchUpInside)
        self.view.addSubview(btn)
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        btn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    deinit {
        debugPrint(#function)
    }
    
    
    @objc func dismissTouched(_ sender:UIButton ) {
        debugPrint(#function)
        self.dismiss(animated: true, completion: nil)
    }
    
}
