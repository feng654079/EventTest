//
//  UIViewControllerType.swift
//  EventTest
//
//  Created by apple on 2021/3/10.
//  Copyright © 2021 apple. All rights reserved.
//

#if os(iOS) || os(tvOS)
import Foundation

public protocol UIViewControllerType {
  func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
}

public protocol UINavigationControllerType {
    func pushViewController(_ viewController: UIViewController, animated: Bool)
}

extension UINavigationController: UIViewControllerType {}
extension UINavigationController: UINavigationControllerType {}

#endif

