//
//  DefaultPresentationController.swift
//  CustomTrastionDemo
//
//  Created by Ifeng科技 on 2020/6/9.
//  Copyright © 2020 Ifeng科技. All rights reserved.
//

import Foundation
import UIKit

protocol PanDismissProgressHandler {
    ///pan手势结束时,触发dismiss的进度阈值
    var dismissTriggerProgress:CGFloat { get }
    
    ///pan手势移动时调用,获取当前dismiss进度 返回值必须 0.0 ~ 1.0
    func progress(for pan:UIPanGestureRecognizer) -> CGFloat
    
    ///pan手势移动和结束时调用,调整UI元素位置
    func adjustUIState(with progress:CGFloat , animated:Bool)
}

//MARK:- DefaultPresentationController

class DefaultPresentationController: UIPresentationController ,PanDismissProgressHandler{
    
    lazy var isAllowTouchDismiss:Bool = true
    lazy var isAllowPanDismiss:Bool = true
    
    /// 处理背景点击事件
    private lazy var _progress:CGFloat = 0.0
    
    private(set) var interactiveController:DefaultInteractiveController? = nil
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    deinit {
        debugPrint("DefaultPresentationController deinit")
    }
    
    var dismissTriggerProgress: CGFloat {
        return 0.3
    }
    
    func progress(for pan:UIPanGestureRecognizer) -> CGFloat {
        let translation = pan.translation(in: self.containerView).y
        let percent = max(0, translation / self.presentedViewController.view.bounds.height)
        return percent
    }
    
    func adjustUIState(with progress:CGFloat , animated:Bool) {
        guard
            let containerView = self.containerView,
            let presentedView = self.presentedView
            else {
                return
        }
        
        let changeBlock = {
            let distance = containerView.bounds.height - presentedView.bounds.height
//            presentedView.frame = CGRect(x: 0, y: distance + progress * distance, width: presentedView.bounds.width, height: presentedView.bounds.height)
            
            let alphaDistance:CGFloat = 0.5
            containerView.backgroundColor = UIColor.black.withAlphaComponent((1 - progress) * alphaDistance)
        }
        
        if animated {
            UIView.animate(withDuration: 0.2) {
                changeBlock()
            }
        } else {
            changeBlock()
        }
    }
    
    private func _addTouchDismissGestureIfNeeded() {
        if isAllowTouchDismiss {
            let tap = UITapGestureRecognizer(target: self, action: #selector(_touchedContainerView(tap:)))
            containerView?.addGestureRecognizer(tap)
        }
    }
    
    @objc private  func _touchedContainerView(tap:UITapGestureRecognizer) {
        if isAllowTouchDismiss {
            self.presentedViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    private func _addPanDismissGestureIfNeeded() {
        if isAllowPanDismiss {
            let pan = UIPanGestureRecognizer(target: self, action: #selector(_panContainerView(pan:)))
            self.containerView?.addGestureRecognizer(pan)
        }
    }
    
    @objc private func _panContainerView(pan:UIPanGestureRecognizer) {
        if pan.state == .began {
            pan.setTranslation(.zero, in: self.containerView)
            self.interactiveController = DefaultInteractiveController(panGestureRecognizer: pan)
            self.presentedViewController.dismiss(animated: true, completion: nil )
        }
        else if pan.state == .changed {
            _progress = progress(for: pan)
            //debugPrint(_progress)
            adjustUIState(with: _progress, animated: false)
        }
        else if pan.state == .changed {
            debugPrint("changed")
            adjustUIState(with: 0.0, animated: false)
            self.interactiveController = nil
        }
    }
}


//MARK:- override system
extension DefaultPresentationController {
    //MARK: Tracking the layout progress
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
    }
    
    //MARK: Tracking the Transition Start and End
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
    
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self ](context) in
            self?.containerView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            self?.presentedViewController.setNeedsStatusBarAppearanceUpdate()
            }, completion: {(context) in })
        
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
       
        self._addTouchDismissGestureIfNeeded()
        self._addPanDismissGestureIfNeeded()
        super.presentationTransitionDidEnd(completed)
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] (context) in
            self?.containerView?.backgroundColor = UIColor.clear
            }, completion: { (context) in })
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
    }
    
}

//MARK:- override UIContentContainer
extension DefaultPresentationController {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
}





