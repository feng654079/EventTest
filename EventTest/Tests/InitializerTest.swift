//
//  InitializerTest.swift
//  EventTest
//
//  Created by apple on 2020/9/18.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

class Food {
    var name: String
    init(name: String) {
        self.name = name
    }
    
    convenience init() {
        self.init(name:"[Unnamed]")
    }
}

class RecipeIngredient: Food {
    var quantity: Int
    
    init(name:String, quantity: Int) {
        self.quantity = quantity
        super.init(name: name)
    }
    
    convenience override init(name: String) {
        self.init(name:name, quantity:1)
    }
}

let r = RecipeIngredient()
