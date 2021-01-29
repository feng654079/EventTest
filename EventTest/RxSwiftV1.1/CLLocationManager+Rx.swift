//
//  CLLocationManager.swift
//  EventTest
//
//  Created by apple on 2020/10/12.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa
import CoreLocation


class RxCLLocationManagerDelegateProxy: DelegateProxy<AnyObject, Any>,
                                        DelegateProxyType,
                                        CLLocationManagerDelegate {
    static func registerKnownImplementations() {
    }
    
    static func currentDelegate(for object: AnyObject) -> Any? {
        let locationManager: CLLocationManager = object as! CLLocationManager
        return locationManager.delegate as? RxCLLocationManagerDelegateProxy
    }
    
    static func setCurrentDelegate(_ delegate: Any?, to object: AnyObject) {
        let locationManager: CLLocationManager = object  as! CLLocationManager
        locationManager.delegate = delegate as? CLLocationManagerDelegate
    }

}

//MARK:-

extension Reactive where Base: CLLocationManager{
    var delegate: DelegateProxy<AnyObject, Any> {
        return RxCLLocationManagerDelegateProxy.proxy(for: base)
    }
    
    var didUpdateLocations: Observable<[CLLocation]> {
        return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didUpdateLocations:)))
            .map { paramenters in
                return paramenters[1] as! [CLLocation]
            }
    }
   
}
