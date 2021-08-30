//
//  ViewController.swift
//  EventTest
//
//  Created by apple on 2020/9/8.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit



class ViewController: UIViewController {
    
    var displayView:YLLongPressDisplayView? = nil
    
    var countDowner = SecondsCountDowner(seconds: 10.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //testAlamofire()
        //testScrollView()
        setupCountDowner()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        debugPrint(self,#function)
       // testThreadSafe()
       // testQuickSort()
        //testBinarySearchTree()
        //sellTicketTest()
        //testAlamofire()
       // testCustomPresent()
        
//        let host = "https://www.baidu.com/?name="
//        let query = String(repeating: "一二三四五六七八九十", count: 1200)
//        let urlStr = "\(host)\(query)"
//        debugPrint(urlStr.urlEncode() ?? "nil")
        
       //debugPrint( UIViewController.getCurrentController())
       // testCountDown()
        
       // testExpressParse()
        testCornerRadius()
    }

    @objc func longPressAction(gesture:UIGestureRecognizer) {
        debugPrint(gesture)
       // displayView?.handleLongPressGesture(gesture: gesture, for: self.view)
    }
    
    func testQuickSort() {
        var arr = [3,2,2,8,9,6,5,1]
        
//        debugPrint("insert sort:\(InsertionSort.insertionSort(arr, <= ))")
//        Sort.quick(arr: &arr, left: 0, right: arr.count - 1)
       // debugPrint("quick sort result:\(arr)")
        let sorted = QuickSort.quickStort(arr) { $0 <= $1 }
        debugPrint("quick sort result:\(sorted)")
        
    }
 
    func test1() {
        let view = TestView()
        view.frame = .init(x: 10, y: 50, width: 300, height: 300)
        self.view.addSubview(view)
        
        let label = UILabel()
        label.frame = .init(x: 10, y: 360, width: 300, height: 300)
        label.attributedText = testAtteri()
        self.view.addSubview(label)
    }
    
    
    func test2() {
        displayView = YLLongPressDisplayView()
        displayView?.frame = self.view.bounds
        self.view.addSubview(displayView!)
        
        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(longPressAction(gesture:)))
        self.view.addGestureRecognizer(longPress)
    }
    
    ///使用分制思想查找有序数组
    func test3() {
       // let sortedArr = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
        let sortedArr:[Int] = []
        
        let testBlock:(_ item:Int) -> Void = {
            (item) in
            let idx = self.findIndex(for: sortedArr, for: item)
            debugPrint("find item:\(item) idx:\(idx ?? -1)")
        }
        
        for item in sortedArr  {
            testBlock(item)
        }
        //获取不存在的item
        testBlock(1000)
    }
  
    func printAllFontNames() {
        let familyNames = UIFont.familyNames
        for familyName in familyNames {
            let fontNames = UIFont.fontNames(forFamilyName: familyName)
            for fontName in fontNames {
                debugPrint(fontName)
            }
        }
    }
    
    func testAlamofire() {
        AlamofireTest().sendTest()
    }
    
    func testThreadSafe() {
        ThreadSafeTest().test()
    }
    
    func testScrollView() {
        let tester = ScrollViewTest()
        tester.testScrollViewTo(view: self.view)
    }
    
    func testBinarySearchTree() {
        let tree = BinarySearchTree.init(array: [7,2,5,10,9,1])
        debugPrint(tree)
        debugPrint(tree.search2(value: 2))
        debugPrint(tree.search2(value: 11))
        tree.search2(value: 2)?.remove()
        debugPrint(tree)
    }
    
    func testCustomPresent() {
        let redVC = DissVC()
        self.showToolBarPresent(viewController: redVC)
        //self.present(redVC, animated: true, completion: nil)
    }
}

extension String {
    ///对网址进行url编码,失败会返回nil
    func urlEncode() -> String? {
        // - https://github.com/Alamofire/Alamofire/issues/206
        // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let generalDelimitersToEncode = ":#[]@"
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        
        var ret:String?
        
        if #available(iOS 8.3, *) {
            ret = self.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
        } else {
            let batchSize = 50
            var index = self.startIndex
            var escaped = ""
            
            while index != self.endIndex {
                let startIndex = index
                let endIndex = self.index(index, offsetBy: batchSize, limitedBy: self.endIndex) ?? self.endIndex
                let range = startIndex..<endIndex
                
                let substring = self[range]
                
                escaped += substring.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? ""
                
                index = endIndex
            }
            if escaped.count > 0 {
                ret = escaped
            }
        }
        return ret
    }
}


//TopK 问题,利用堆来处理

struct Sort {
   static func quick(arr: inout [Int],left:Int ,right:Int) {
        guard arr.count > 0, left < right else {
            return
        }
        let base = arr[left]
        var l = left
        var r = right
        while l != r {
            ///从右向左找到一个小于基准值的数
            while r > l && arr[r] >= base {
                r -= 1
            }
            
            ///从左向右找到一个大于基准值的数
            while l < r && arr[l] <= base {
                l += 1
            }
            if l < r {
               let t = arr[l]
                arr[l] = arr[r]
                arr[r] = t
            }
            
        }
       arr[l] = base
       quick(arr: &arr, left: left, right: l - 1)
       quick(arr: &arr, left: l + 1, right: right)
    }

}


fileprivate var count = 0
fileprivate var totalTime:TimeInterval = 0.0
fileprivate let times = 5
fileprivate let queue = DispatchQueue.init(label: "sell.queue")
fileprivate let lock = NSLock()
fileprivate let semphore = DispatchSemaphore(value: 1)
fileprivate let myLock = PerfectLock.GetLock()
fileprivate let unFairLock: os_unfair_lock_t = .allocate(capacity: 1)
extension ViewController {
    func sellTicketTest() {
        guard count < times else { return }
        debugPrint("begin...")
        count += 1
        var num = 20
        let start = Date().timeIntervalSince1970
 
        for _ in 0..<num {
            DispatchQueue.global().async {
               // lock.lock()
                //semphore.wait()
                myLock.lock()
                //os_unfair_lock_lock(unFairLock)
                num -= 1
                if num == 0 {
                    let cost = Date().timeIntervalSince1970 - start
                    debugPrint("cost:\(cost)")
                    totalTime += cost
                    if count == times {
                        debugPrint("avg time:\(totalTime / TimeInterval(count))")
                    }
                }
               //os_unfair_lock_unlock(unFairLock)
               myLock.unlock()
               // semphore.signal()
                //lock.unlock()
            }
//            queue.async {
//                num -= 1
//            debugPrint("剩余票数:\(num)")
//                if num == 0 {
//                   debugPrint("cost:\(Date().timeIntervalSince1970 - start)")
//                }
//            }
        }
    }
}


//MARK: - test count down
extension ViewController {
    func setupCountDowner() {
        countDowner.set { (scd, second) in
            debugPrint("count down:\(second)")
            if second < 6 {
                scd.pause()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    scd.resume()
                }
            }
            
        }
    }
    
    
    func testCountDown() {
        countDowner.resume()
    }
}


extension ViewController {
    func testExpressParse() {
        do {
            let exp = "12 * (3 + 4) - 6 + 8 / 2"
            let parser = EvaluateExpressionParser()
            parser.parse(expression: exp)
            debugPrint("exp:\(exp)")
            debugPrint("parse result:\(parser.getTokens())")
            debugPrint("right post fix:12 3 4 + * 6 - 8 2 / +")
            debugPrint("post fix \(parser.infixExpressToPostfixExpress().joined(separator: " "))")
            if let result = parser.result {
                debugPrint("result :\(result)")
            } else {
                debugPrint("计算失败")
            }
        }
        
        do {
            let exp = "8299 + 3999 + 300"
            let parser = EvaluateExpressionParser()
            parser.parse(expression: exp)
            if let result = parser.result {
                debugPrint("result :\(result)")
            } else {
                debugPrint("计算失败")
            }
        }
        
        
        do {
            let exp = "(6 + 3) * 4"
            let parser = EvaluateExpressionParser()
            parser.parse(expression: exp)
            if let result = parser.result {
                debugPrint("result :\(result)")
            } else {
                debugPrint("计算失败")
            }
        }
    }
}

//MARK: - test coradius

extension ViewController {
    func testCornerRadius() {
        let controlPoint = CGPoint(x: 200, y: 200)
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.red.cgColor
        layer.path = UIBezierPath.createMaskRoundedCorners(controlPoint: controlPoint, verticalLen: 20, horizentalLen: 20, direction: .toRightBottom).cgPath
        view.layer.addSublayer(layer)
    }
}


extension UIBezierPath {
    
    enum Direction {
        case toLeftTop
        case toLeftBottom
        case toRightTop
        case toRightBottom
    }
    
    /// 绘制一个圆角这招路径
    /// - Parameters:
    ///   - controlPoint: 控制点
    ///   - verticalLen: 水平大小
    ///   - horizentalLen: 竖直方向的长度
    ///   - direction: 圆角开口的相对于控制点的朝向
    /// - Returns: 返回反圆角路径
    static func createMaskRoundedCorners
    (controlPoint:CGPoint,verticalLen:CGFloat,horizentalLen:CGFloat ,direction:Direction)
    -> UIBezierPath {
        
        let firstPoint:CGPoint
        let secondPoint:CGPoint
        switch direction {
        case .toLeftTop:
            firstPoint = CGPoint(x: controlPoint.x - horizentalLen, y: controlPoint.y)
            secondPoint = CGPoint(x: controlPoint.x, y: controlPoint.y - verticalLen)
        case .toLeftBottom:
            firstPoint = CGPoint(x: controlPoint.x - horizentalLen, y: controlPoint.y)
            secondPoint = CGPoint(x: controlPoint.x, y: controlPoint.y + verticalLen)
        case .toRightTop:
            firstPoint = CGPoint(x: controlPoint.x + horizentalLen, y: controlPoint.y)
            secondPoint = CGPoint(x: controlPoint.x , y: controlPoint.y - verticalLen)
        case .toRightBottom:
            firstPoint = CGPoint(x: controlPoint.x + horizentalLen, y: controlPoint.y)
            secondPoint = CGPoint(x: controlPoint.x , y: controlPoint.y + verticalLen)
        }
        
        let path = UIBezierPath()
        path.move(to: firstPoint)
        path.addQuadCurve(to: secondPoint, controlPoint: controlPoint)
        path.addLine(to: controlPoint)
        path.close()
        return path
    }
}

