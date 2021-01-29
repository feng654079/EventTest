//
//  InitTest.swift
//  EventTest
//
//  Created by apple on 2020/9/27.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import UIKit

//MARK: 初始化测试
extension ViewController {
    
    struct Person {
        var name:String? ///可选值默认是nil
        var age:Int
        
        
    }
    
    class MyView: UIView {
        var testProperty:Int = 0
        
        let donthaveInitalValue: String
    
        var varStr: String
        init(frame: CGRect,donthaveInitalValue:String) {
            self.donthaveInitalValue = donthaveInitalValue
            self.varStr = ""
            super.init(frame: frame)
            
        }
        
        required init?(coder: NSCoder) {
            self.donthaveInitalValue = ""
            self.varStr = ""
            super.init(coder: coder)
           
        }
    }
    
    func initTest() {
       
    }
    
}
