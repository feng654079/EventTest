//
//  NavigatorProtocol.swift
//  EventTest
//
//  Created by apple on 2021/3/10.
//  Copyright © 2021 apple. All rights reserved.
//

import Foundation

#if os(iOS) || os(tvOS)

public typealias URLPattern = String
public typealias ViewControllerFactory = (_ url: URLConvertible, _ values:[String:Any], _ context:Any?) -> UIViewController?
public typealias URLOpenHandlerFactory = (_ url: URLConvertible, _ values:[String:Any], _ context:Any?) -> Bool
public typealias URLOpenHandler = () -> Bool

//MARK: - 
public protocol NavigatorProtocol: class {
    var delegate: NavigatorDelegate? { get set }
    
    func register(_ pattern:URLPattern, _ factory: @escaping ViewControllerFactory)
    func handle(_ pattern:URLPattern, _ factory: @escaping URLOpenHandlerFactory)
    
    func viewController(for url:URLConvertible,context: Any?) -> UIViewController?
    func handler(for url:URLConvertible,context:Any?) -> URLOpenHandler?
    
    @discardableResult
    func push(_ url: URLConvertible, context:Any? ,from: UINavigationControllerType , animated: Bool) -> UIViewController?
    
    @discardableResult
    func present(_ url:URLConvertible,context:Any? ,wrap: UINavigationController.Type,from: UIViewControllerType? ,animated: Bool, completion: (()->Void)?) -> UIViewController?
    
    @discardableResult
    func open(_ url: URLConvertible, context:Any?) -> Bool
    
}

//MARK: -
public protocol NavigatorDelegate: class {
    func shouldPush(viewController: UIViewController,from: UINavigationControllerType) -> Bool
    
    func shouldPresent(viewController: UIViewController, frome: UIViewControllerType) -> Bool
}

extension NavigatorDelegate {
    public func shouldPush(viewController: UIViewController,from: UINavigationControllerType) -> Bool {
         return true
    }
    
    public func shouldPresent(viewController: UIViewController, frome: UIViewControllerType) -> Bool {
        return true
    }
}

#endif
