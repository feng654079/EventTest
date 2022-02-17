//
//  UIColor+Ex.swift
//  AnimationDemo
//
//  Created by apple on 2021/10/20.
//  Copyright © 2021 apple. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    ///随机生成颜色
    static  var random: UIColor {
        func randomColorComponent() -> CGFloat {
            return CGFloat(arc4random() % 255) / 255.0
        }
        return UIColor.init(red: randomColorComponent(), green: randomColorComponent(), blue: randomColorComponent(), alpha: 1.0)
    }
}
