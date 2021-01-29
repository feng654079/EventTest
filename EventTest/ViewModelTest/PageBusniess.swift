//
//  VIewBusniess.swift
//  EventTest
//
//  Created by apple on 2020/9/15.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

protocol PageBusniess {
    
    ///获取网络数据
    func fetchNetworkDataData()
    
    ///刷新正常情况下的UI
    func refreshUI()
    
    ///展示数据错误时的UI
    func showErrorUI()
    
    ///展示提示UI
    func showTip(msg: String)
    
}
