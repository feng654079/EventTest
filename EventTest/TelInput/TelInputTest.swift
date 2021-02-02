//
//  TelInputTest.swift
//  EventTest
//
//  Created by apple on 2021/2/2.
//  Copyright © 2021 apple. All rights reserved.
//

import Foundation
import UIKit

extension String {
    ///是否为数字
    var isDecimalDigits: Bool {
        for s in self.unicodeScalars {
            if !CharacterSet.decimalDigits.contains(s) {
                return false
            }
        }
        return true
    }
    
    ///指定位置添加空格
    mutating func addSpace(at index:Int) {
        if let s = self.index(self.startIndex, offsetBy: index ,limitedBy: endIndex) {
            self.insert(" ", at: s)
        }
    }
    
    ///为电话号码添加空格
    mutating func addOrRemoveSpaceForTelIfNeeded()  {
        let length = self.count
        //添加空格
        if length <= 13 {
            ///多了一个空格
            if length == 9 {
                self.addSpace(at: 8)
            }
            else if length == 4 {
                self.addSpace(at: 3)
            }
        }
        else {
            //移除空格
            self = self.split(separator: " ").joined()
        }
    }
    
    mutating func removeSpaceIfNeeded() {
        let length = self.count
        if self.contains(" ") {
            if length == 9 {
                self = String(self.dropLast())
            }
            else if length == 4 {
                self = String(self.dropLast())
            }
        } else {
            /// 删除过程中如果 删除到11位还要添加空格
            if length == 11 {
               self.addSpace(at: 3)
               self.addSpace(at: 8)
            }
        }
    }
}

extension NSRange {
    func toStringIndexRange(for str:String) -> Range<String.Index>? {
        guard location + length <= str.count else {
            return nil
        }
        let start = str.index(str.startIndex, offsetBy:location)
        let end = str.index(start, offsetBy: length)
        return start..<end
    }
}

//MARK: -
extension UITextField {
    func telText(shouldChangeCharactersIn range:NSRange,replacementString string:String) -> Bool {
        debugPrint(range,string)
        var str = text ?? ""
        guard let r = range.toStringIndexRange(for: str) else {
            return false
        }
        // 正在删除字符
        if string.count == 0 {
            str.replaceSubrange(r, with: string)
            str.removeSpaceIfNeeded()
        }
        //添加字符
        else {
            guard string.isDecimalDigits else {
                return false
            }
            str.replaceSubrange(r, with: string)
            str.addOrRemoveSpaceForTelIfNeeded()
        }
        self.text = str
        return false
    }
}

//MARK: -
/**
 微信登录页面手机号输入效果
 */
class TelInputViewController: UIViewController {
    let telInput = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        telInput.translatesAutoresizingMaskIntoConstraints  = false
        telInput.delegate = self
        telInput.font = UIFont.systemFont(ofSize: 24.0)
        telInput.layer.borderWidth = 1.0
        telInput.layer.borderColor = UIColor.lightGray.cgColor
        view.addSubview(telInput)
        
        telInput
            .topAnchor.constraint(equalTo: view.topAnchor, constant: 40.0).isActive = true
        telInput
            .leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20.0).isActive = true
        telInput
            .rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20.0).isActive = true
        telInput.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
    }
}

extension TelInputViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == telInput {
            return telInput.telText(shouldChangeCharactersIn: range, replacementString: string)
        }
        return true
    }
}
