//
//  MKMapView+Rx.swift
//  EventTest
//
//  Created by apple on 2020/10/13.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import MapKit
import RxSwift
import RxCocoa


class RXMKMapViewDelegateProxy: DelegateProxy<AnyObject,Any>, MKMapViewDelegate , DelegateProxyType {
    static func registerKnownImplementations() {
    
    }

    static func currentDelegate(for object: AnyObject) -> Any? {
        let mapView: MKMapView = object as! MKMapView
        return mapView.delegate
    }
    
    static func setCurrentDelegate(_ delegate: Any?, to object: AnyObject) {
        
        let mapView: MKMapView = object as! MKMapView
        mapView.delegate = delegate as? MKMapViewDelegate
    }
}


//MARK:-

extension Reactive where Base: MKMapView {
    
    public func setDelegate(_ delegate:MKMapViewDelegate) -> Disposable {
        return RXMKMapViewDelegateProxy.installForwardDelegate(delegate, retainDelegate: false, onProxyForObject: self.base)
    }
    
    
   public var overlays: Binder<[MKOverlay]> {
        return Binder<[MKOverlay]>.init(self.base) { (mapView, overlays) in
            mapView.removeOverlays(mapView.overlays)
            mapView.addOverlays(overlays)
        }
    }
    
    public var regionDidChangeAnimated: ControlEvent<Bool> {
        let source = methodInvoked(#selector(MKMapViewDelegate.mapView(_:regionDidChangeAnimated:)))
            .map {
                parameters in
                return (parameters[1] as? Bool) ?? false
            }
        return ControlEvent(events: source)
    }

    public var centerCoordinate:Binder<CLLocationCoordinate2D> {
        return Binder<CLLocationCoordinate2D>(self.base) {
            (mapView ,center) in
            mapView.setCenter(center, animated: true)
        }
    }
    
}
