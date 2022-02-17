//
//  InJectionHelper.swift
//  TextEditingDemo
//
//  Created by apple on 2021/12/6.
//  Copyright © 2021 apple. All rights reserved.
//

import Foundation

class JectionHelper {
    
    static func initilazie() {
#if DEBUG
        let bundle =  Bundle.init(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle")
        debugPrint(bundle)
         bundle?.load()
#endif
        
    }
    
}
