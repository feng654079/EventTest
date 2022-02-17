//
//  AnimationKeyPath.swift
//  AnimationDemo
//
//  Created by apple on 2021/10/19.
//  Copyright © 2021 apple. All rights reserved.
//

import Foundation
import Alamofire

struct AnimationKeyPath: RawRepresentable {
   
    private(set) var rawValue: String
    
    typealias RawValue = String
    
    init(rawValue: String) {
        self.rawValue = rawValue
    }
}

//MARK: -
extension AnimationKeyPath {
    static var anchorPoint:AnimationKeyPath {
        return AnimationKeyPath(rawValue: "anchorPoint")
    }
    
    static var backgroundColor:AnimationKeyPath {
        return AnimationKeyPath(rawValue: "backgroundColor")
    }
    
    static var backgroundFilters:AnimationKeyPath {
        return AnimationKeyPath(rawValue: "backgroundFilters")
    }
    
    static var borderColor:AnimationKeyPath {
        return AnimationKeyPath(rawValue: "borderColor")
    }
    
    static var borderWidth:AnimationKeyPath {
        return AnimationKeyPath(rawValue: "borderWidth")
    }
    

    static var compositingFilter:AnimationKeyPath {
        return AnimationKeyPath(rawValue: "compositingFilter")
    }
    
    static var contents:AnimationKeyPath {
        return AnimationKeyPath(rawValue: "contents")
    }
    
    static var contentsRect:AnimationKeyPath {
        return AnimationKeyPath(rawValue: "contentsRect")
    }
    
    static var cornerRadius:AnimationKeyPath {
        return AnimationKeyPath(rawValue: "cornerRadius")
    }
    
    static var doubleSided:AnimationKeyPath {
        return AnimationKeyPath(rawValue: "doubleSided")
    }
    
    static var filters:AnimationKeyPath {
        return AnimationKeyPath(rawValue: "filters")
    }
    
    static var hidden:AnimationKeyPath {
        return AnimationKeyPath(rawValue: "hidden")
    }
    
    static var mask:AnimationKeyPath {
        return AnimationKeyPath(rawValue: "mask")
    }
    
    static var maskToBounds:AnimationKeyPath {
        return AnimationKeyPath(rawValue: "maskToBounds")
    }
    static var opacity: AnimationKeyPath {
        return AnimationKeyPath(rawValue: "opacity")
    }

    static var shadowColor:AnimationKeyPath {
        return AnimationKeyPath(rawValue: "shadowColor")
    }
    
    static var shadowOffset:AnimationKeyPath {
        return AnimationKeyPath(rawValue: "shadowOffset")
    }
    
    static var shadowOpacity: AnimationKeyPath {
        return AnimationKeyPath(rawValue: "shadowOpacity")
    }
    static var shadowPath: AnimationKeyPath {
        return AnimationKeyPath(rawValue: "shadowPath")
    }
    
    static var shadowRadius:AnimationKeyPath {
        return AnimationKeyPath(rawValue: "shadowRadius")
    }
    
    static var sublayers:AnimationKeyPath {
        return AnimationKeyPath(rawValue: "sublayers")
    }
    
    static var sublayersTransform:AnimationKeyPath {
        return AnimationKeyPath(rawValue: "sublayersTransform")
    }
    
    static var zPosition:AnimationKeyPath {
        return AnimationKeyPath(rawValue: "zPosition")
    }
}
  
//MARK: - Transform
extension AnimationKeyPath {
    static var transform:AnimationKeyPath {
        return AnimationKeyPath(rawValue: "transform")
    }
    
    static var tranformRotationX:AnimationKeyPath {
        return AnimationKeyPath(rawValue: "transform.rotation.x")
    }
    
    static var tranformRotationY:AnimationKeyPath {
        return AnimationKeyPath(rawValue: "transform.rotation.y")
    }
    
    static var tranformRotationZ:AnimationKeyPath {
        return AnimationKeyPath(rawValue: "transform.rotation.z")
    }
    
    static var transformScaleX:AnimationKeyPath {
        return AnimationKeyPath(rawValue: "transform.scale.x")
    }
    
    static var transformScaleY:AnimationKeyPath {
        return AnimationKeyPath(rawValue: "transform.scale.y")
    }
    
    static var transformScaleZ:AnimationKeyPath {
        return AnimationKeyPath(rawValue: "transform.scale.z")
    }
    
    static var transformTranslationX:AnimationKeyPath {
        return AnimationKeyPath(rawValue: "transform.translation.x")
    }
    
    static var transformTranslationY:AnimationKeyPath {
        return AnimationKeyPath(rawValue: "transform.translation.y")
    }
    
    static var transformTranslationZ:AnimationKeyPath {
        return AnimationKeyPath(rawValue: "transform.translation.z")
    }
}


//MARK: - position key paths
extension AnimationKeyPath {
    static var position:AnimationKeyPath {
        return AnimationKeyPath(rawValue: "position")
    }
    
    static var positionX:AnimationKeyPath {
        return AnimationKeyPath(rawValue: "position.x")
    }
    
    static var positionY:AnimationKeyPath {
        return AnimationKeyPath(rawValue: "position.y")
    }
}


//MARK: - Size key paths

extension AnimationKeyPath {
    static var sizeWidth:AnimationKeyPath {
        return AnimationKeyPath(rawValue: "size.width")
    }
    
    static var sizeHeight:AnimationKeyPath {
        return AnimationKeyPath(rawValue: "size.height")
    }
}


//MARK: - bounds key paths
extension AnimationKeyPath {
    static var bounds:AnimationKeyPath {
        return AnimationKeyPath(rawValue: "bounds")
    }
    
    static var boundsSize:AnimationKeyPath {
        return AnimationKeyPath(rawValue: "bounds.size")
    }
    
    static var boundsSizeWidth:AnimationKeyPath {
        return AnimationKeyPath(rawValue: "bounds.size.width")
    }
    
    static var boundsSizeHeight:AnimationKeyPath {
        return AnimationKeyPath(rawValue: "bounds.size.height")
    }
}

//MARK: - frame key paths
extension AnimationKeyPath {
    static var frame:AnimationKeyPath {
        return AnimationKeyPath(rawValue: "frame")
    }
    
    static var frameOrigin:AnimationKeyPath {
        return AnimationKeyPath(rawValue: "frame.origin")
    }
    
    static var frameOriginX:AnimationKeyPath {
        return AnimationKeyPath(rawValue: "frame.origin.x")
    }
    
    static var frameOriginY:AnimationKeyPath {
        return AnimationKeyPath(rawValue: "frame.origin.y")
    }
    
    static var frameSize:AnimationKeyPath {
        return AnimationKeyPath(rawValue: "frame.size")
    }
    
    static var frameSizeWidth:AnimationKeyPath {
        return AnimationKeyPath(rawValue: "frame.size.width")
    }
    
    static var frameSizeHeight:AnimationKeyPath {
        return AnimationKeyPath(rawValue: "frame.size.height")
    }
    
}


//MARK: - CAShapeLayer Key Paths
extension AnimationKeyPath {
    static var strokeEnd:AnimationKeyPath {
        return AnimationKeyPath(rawValue: "strokeEnd")
    }
}
