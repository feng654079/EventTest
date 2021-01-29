//
//  ScrollViewTest.swift
//  EventTest
//
//  Created by apple on 2020/9/30.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

struct ScrollViewTest {
    
    func createTestScrollView() -> UIScrollView {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.backgroundColor = UIColor.white
        
        let scrollContentView = UIView(frame: .zero)
        scrollContentView.backgroundColor = UIColor.lightGray
        
        let subView = UIView(frame: .zero)
        subView.backgroundColor = UIColor.green
        
        
        scrollView.addSubview(scrollContentView)
        scrollContentView.addSubview(subView)

     
        scrollContentView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(scrollView)
           // maker.center.equalTo(scrollView)
            maker.height.equalTo(scrollView)
           // maker.width.equalTo(1000.0)
        }
        
        
        subView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(scrollContentView).inset(10)
            maker.width.equalTo(1000.0)
        }
        
        
        return scrollView
    }
    
    func testScrollViewTo(view:UIView) {
        let scrollView = self.createTestScrollView()
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints {
            $0.left.equalTo(view)
            $0.right.equalTo(view)
            $0.height.equalTo(50)
            $0.top.equalTo(300)
        }
    }
}
