//
//  NestedScrollDemoVC.swift
//  EventTest
//
//  Created by apple on 2020/12/30.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

class NestedScrollDemoVC: UIViewController {
    let scrollView = MyScrollView()
    let childVC = NestedVC()
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.frame = self.view.bounds
        scrollView.contentSize = .init(width: self.view.bounds.width, height: 1500.0)
        view.addSubview(scrollView)
        
        let childVCView = childVC.view
        self.addChild(childVC)
        childVCView!.frame = .init(x: 0.0, y: 500.0, width: view.bounds.width, height: view.bounds.height - 500.0)
        scrollView.addSubview(childVCView!)
        scrollView.inScrollChild = childVC.tableView
        
        scrollView.becomeDelegate()
    }
}

//MARK: -
class NestedVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.backgroundColor = UIColor.lightGray
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        tableView.frame = self.view.bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
}

//MARK: -
class MyScrollView: UIScrollView {
    var inScrollChild: UIScrollView?
    
    //MARK: 手势识别
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        debugPrint(#function)
    }
    
    override func touchesShouldBegin(_ touches: Set<UITouch>, with event: UIEvent?, in view: UIView) -> Bool {
        debugPrint(#function)
        return super.touchesShouldBegin(touches, with: event, in: view)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        debugPrint(#function)
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        debugPrint(#function)
        super.touchesEnded(touches, with: event)
    }
    
    //MARK: 寻找第一响应者
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        debugPrint(#function)
        //return super.hitTest(point, with: event)
        //return systemHitTest(point, with: event)
        return _hitTest(point, with: event)
    }

    private func _hitTest(_ point:CGPoint, with event: UIEvent?) -> UIView?  {
        guard self.isUserInteractionEnabled == false ||
              self.isHidden == false ||
              self.alpha > 0.0
          else  {
              return nil
          }
        
        guard self.point(inside: point, with: event) else {
            return nil
        }
        
        if let sc = self.inScrollChild {
           let p = self.convert(point, to: self.inScrollChild)
            if sc.frame.contains(p) {
                if self.contentOffset.y < 1 {
                    debugPrint("包含")
                    return self
                }
            }
        }
        
        var idx = subviews.count - 1
        while idx >= 0 {
            let childView = subviews[idx]
            let childPoint = self.convert(point, to: childView)
            if let finded = childView.hitTest(childPoint, with: event) {
                return finded
            }
            idx -= 1
        }
        
        return self
    }
    
    private func systemHitTest(_ point:CGPoint, with event: UIEvent?) -> UIView? {
      guard self.isUserInteractionEnabled == false ||
            self.isHidden == false ||
            self.alpha > 0.0
        else {
            return nil
        }
        
        guard self.point(inside: point, with: event) else {
            return nil
        }
        
        var idx = subviews.count - 1
        while idx >= 0 {
            let childView = subviews[idx]
            let childPoint = self.convert(point, to: childView)
            if let finded = childView.hitTest(childPoint, with: event) {
                return finded
            }
            idx -= 1
        }
        
        return self
    }
}

extension MyScrollView: UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    func becomeDelegate() {
        self.delegate = self
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        debugPrint(#function)
        return true
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
      //  debugPrint(#function)
        if scrollView.contentOffset.y > 200 {
            scrollView.contentOffset.y = 200
            if inScrollChild?.canBecomeFirstResponder ?? false {
                debugPrint("更换第一响应者")
                inScrollChild?.becomeFirstResponder()
            }
        }
    }
}
