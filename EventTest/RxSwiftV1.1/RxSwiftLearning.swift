//
//  RxSwiftLearning.swift
//  EventTest
//
//  Created by apple on 2020/10/9.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import UIKit

import RxCocoa
import RxSwift

class RxSwiftLearingListViewController:UITableViewController {
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.rx.contentOffset.subscribe { (event) in
//            debugPrint(event)
//        }.disposed(by: disposeBag)
        
        tableView.rx.willEndDragging
            .subscribe(onNext:{
            e in
            debugPrint(e.velocity)
            debugPrint(e.targetContentOffset)
           
        }).disposed(by: disposeBag)
        
        tableView.rx.didEndDragging
            .subscribe(onNext:{
            e in
            debugPrint(e)
        }).disposed(by: disposeBag)
        
        
    }
}


class RxSwiftLearningViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        //_Section_II_Chapter_9_Combining_Operators()
       // _Section_II_Chapter_10_Combining_Operators_in_Practice()
        
        
        for f in UIFont.familyNames {
            for s in UIFont.fontNames(forFamilyName: f) {
                debugPrint(s)
            }
        }
        
    
      //  _Section_III_Chapter_15_Intro_To_Schedulers()
        
       
    }
    
}

fileprivate func _example(name:String,action:()->Void) {
    debugPrint("Example of: -- \(name) -- ")
    action()
    debugPrint()
}



extension RxSwiftLearningViewController {
    
    private func _Section_III_Chapter_15_Intro_To_Schedulers() {
        
        _example(name: "Switching schedulers") {
            let fruit = Observable<String>.create { (observer) -> Disposable in
                observer.onNext("[apple]")
                sleep(2)
                observer.onNext("[pineapple]")
                sleep(2)
                observer.onNext("[strawberry]")
                return Disposables.create()
            }
            
            fruit
                .debug("")
                .subscribe()
                .disposed(by: disposeBag)
            
            //dump 函数 和dump 
        }
    }
    
    
    private func _Section_IV_Chapter_14_Error_Hanlding_in_Practice() {
        
        ///RxSwift的错误处理机制: catch 覆盖错误, retry 重试
        //Look up Weather.swifts
    }
    
    
    private func _Section_III_Chapter_12_Intermediate_RxCocoa() {
        //Look up Weather.swifts
    }
    
    private func _Section_III_Chapter_11_Beginning_RxCocoa() {
        //Look up Weather.swift
    }
   
    private func _Section_II_Chapter_10_Combining_Operators_in_Practice() {
        
        _example(name: "categories view Controller request categories") {
            
            //接受事件的序列
            let categories = BehaviorRelay<[EOCategory]>(value: [])
            
            _ = (categories.value.count)
            
            if let category = categories.value.first {
                debugPrint(category)
            }
            
            ///和服务器API绑定
            EONET.categories
                .bind(to: categories)
                .disposed(by: disposeBag)
            
            ///订阅序列更新UI
            categories
                .subscribe { (categoryList) in
                    
                    DispatchQueue.main.async {
                        ///reload ui
                    }
                   
                } onError: { (error) in
                    
                } onCompleted: {
                    
                } onDisposed: {
                    
                }
                .disposed(by: disposeBag)
            
            
        }
        
        ///这里是重点,需要重点复习
        ///业务是有一个分类列表,并展示每个分类下的事件, 先请求分类,然后请求每个分类下的事件
        _example(name: "categories view Controller request categories and events for every category") {
            
            //接受事件的序列
            let categories = BehaviorRelay<[EOCategory]>(value: [])
            
            
            //请求分类的序列
            let eoCategories = EONET.categories
            
            //请求到分类数组后,遍历每一个分类,请求每一个分类下的事件数组
            let downloadedEvents = eoCategories.flatMap {
                categories in
                return Observable.from(categories.map {
                    category in
                    EONET.events(forLast: 360, category: category)
                })
            }.merge(maxConcurrent: 2)  ///合并所有事件数组的请求序列的元素,并且制定最大并发数是2
            
        
            // 遍历所有分类和事件,填充分类下的事件数组
            let updatedCategories = eoCategories.flatMap {
                categories in
                downloadedEvents.scan(categories) {
                    updated , events in
                    return updated.map {
                        category in
                        let eventsForCategory = EONET.filteredEvents(events: events, for: category)
                        if !eventsForCategory.isEmpty {
                            var cat = category
                            cat.events = cat.events + eventsForCategory
                            return cat
                        }
                        return category
                    }
                }
            }
            
            ///分类请求完毕之后才能更新分类下的事件数组,所以用concat
            eoCategories
                .concat(updatedCategories)
                .bind(to: categories)
                .disposed(by: disposeBag)

            ///订阅序列更新UI
            categories
                .subscribe { (categoryList) in

                    DispatchQueue.main.async {
                        ///reload ui
                    }

                } onError: { (error) in

                } onCompleted: {

                } onDisposed: {

                }
                .disposed(by: disposeBag)
        }

        _example(name: "event view controller display ui") {
            let events = BehaviorRelay<[EOEvent]>(value:[])
        
            let days = BehaviorRelay<Int>(value: 360)
            let filterEvents =  BehaviorRelay<[EOEvent]>(value:[])
           
            ///根据一定的条件过滤event
            Observable.combineLatest(days, events) { (d, e) -> [EOEvent] in
                let maxInterval = TimeInterval(d * 24 * 3600)
                return e.filter {
                     $0.closedDate > maxInterval
                }
            }
            .bind(to: filterEvents)
            .disposed(by: disposeBag)
            
            events.subscribe(onNext: {
                //[weak self]
                _ in
                // tableview reload ui
            }).disposed(by: disposeBag)
            
            filterEvents
                .subscribe(onNext: {
                   // [weak self]
                    _ in
                    // tableview reload ui
                }).disposed(by: disposeBag)
            
            days
                .subscribe(onNext: {
                    // [weak self]
                     _ in
                     // update display for days
                 }).disposed(by: disposeBag)
            
        }
    
        
        ///这样实现是否好?
        _example(name: "挑战1:网络请求开始时转菊花,结束时停止转菊花") {
            
            let myRequest = Observable<[String]>.create { (ob) -> Disposable in
                ///模拟网络请求
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                    ob.onNext(["网络","请求","完成"])
                    ob.onCompleted()
                }
                return Disposables.create()
            }
            
            myRequest
                .do(
                    onCompleted: {
                        debugPrint("隐藏菊花")
                    },
                    onSubscribed: {
                        debugPrint("开始转菊花")
                    }
                )
                .debug("挑战1")
                .subscribe()
                .disposed(by: disposeBag)
            
         
        }
        
        ///不会
        _example(name: "挑战2:增加下载进度指示器") {

        }
        
    }
    
    private func _Section_II_Chapter_9_Combining_Operators() {
        //向序列开始插入一个元素
        _example(name: "startWith") {
            
            let observable = Observable.of(2,3,4)
            
            observable
                .startWith(1)
                .debug("startWith")
                .subscribe()
                .disposed(by: disposeBag)
        }
        
        //两个序列按照顺序将他们的元素放到一个新的序列中
        _example(name: "Obserable.concat") {
            let first = Observable.of(1,2,3)
            let second = Observable.of(4,5,6)
            let obserable = Observable.concat([first,second])
            obserable
                .debug("Obserable.concat")
                .subscribe()
                .disposed(by: disposeBag)
            
        }
        
        //合并订阅多个序列,当任意一个序列发出元素时,订阅者都能收到
        _example(name: "merage") {
            let left  = PublishSubject<String>()
            let right = PublishSubject<String>()
            let source = Observable.of(left.asObservable(),right.asObservable())
            source
                .merge()
                .debug("merge")
                .subscribe()
                .disposed(by: disposeBag)
            
            var leftValues = ["Berlin", "Munich", "Frankfurt"]
            var rightValues = ["Madrid", "Barcelona", "Valencia"]
            repeat {
                if arc4random_uniform(2) == 0 {
                    if !leftValues.isEmpty {
                        left.onNext("Left: " + leftValues.removeFirst())
                    }
                } else if !rightValues.isEmpty {
                    right.onNext("Right: " + rightValues.removeFirst())
                }
                
            } while !leftValues.isEmpty || !rightValues.isEmpty
            
            left.onCompleted()
            debugPrint("left onCompleted")
            right.onCompleted()
            debugPrint("right onCompleted")
        }
        
        //用多个序列的最新元素,调用合并算法,合并为一个元素,然后发出
        _example(name: "combineLatest") {
            let left = PublishSubject<String>()
            let right = PublishSubject<String>()
            
            let observable = Observable.combineLatest(left, right) { (eLeft, eRight) -> String in
                return "\(eLeft) \(eRight)"
            }
            observable
                .debug("combineLatest")
                .subscribe()
                .disposed(by: disposeBag)
            
            print("> Sending a value to Left")
            left.onNext("Hello,")
            print("> Sending a value to Right")
            right.onNext("world")
            print("> Sending another value to Right")
            right.onNext("RxSwift")
            print("> Sending another value to Left")
            left.onNext("Have a good day,")
        }
        
        _example(name: "combine user choice and value") {
            let choice :Observable<DateFormatter.Style> = Observable.of(.short,.long)
            let dates = Observable.of(Date())
            let observable = Observable.combineLatest(choice, dates) { (e1, e2) -> String in
                let formatter = DateFormatter()
                formatter.dateStyle = e1
                return formatter.string(from: e2)
            }
            
            observable
                .debug()
                .subscribe()
                .disposed(by: disposeBag)
            
        }
        
        //按照多个序列中元素的索引顺序,调用合并算法合并索引值相同的元素,然后将合并后的元素发出,直到某一个序列没有元素为止.
        _example(name: "zip") {
            enum Weather {
                case cloudy
                case sunny
            }
            
            let left = Observable<Weather>.of(.sunny,.cloudy,.cloudy,.sunny)
            let right = Observable<String>.of("Lisbon", "Copenhagen", "London", "Madrid", "Vienna")
            let observable = Observable.zip(left, right) {
                weather,city in
                return "It's \(weather) in \(city)"
            }
            observable
                .debug("zip")
                .subscribe()
                .disposed(by: disposeBag)
            
        }
        
        ///当一个序列开始发送元素时,忽略它,转而发送另一个元素的最新值,
        ///相当于当一个序列有元素时,获取另一个序列的最新值
        ///e.g当按钮点击时,获取txtfield的内容
        _example(name: "withLatestFrom and sample") {
            
            ///还有类似的操作符 Sample
            
            let button = PublishSubject<Void>()
            let textField = PublishSubject<String>()
            
            let observable = button.withLatestFrom(textField)
            let observable2 = textField.sample(button)
            
            observable
                .debug("withLatestFrom")
                .subscribe()
                .disposed(by: disposeBag)
            
            observable2
                .debug("Sample")
                .subscribe()
                .disposed(by: disposeBag)
            
            // 3
            textField.onNext("Par")
            textField.onNext("Pari")
            textField.onNext("Paris")
            button.onNext(Void())
            button.onNext(Void())
        }
        
        ///合并订阅序列,哪个序列先发出元素,就订阅那个序列,忽略其他的序列
        _example(name: "amb") {
           
            let left = PublishSubject<String>()
            let right = PublishSubject<String>()
            
            //哪个序列先发送元素就订阅哪个
            let observable = left.amb(right)
            
            observable
                .debug("amb")
                .subscribe()
                .disposed(by: disposeBag)
            
            // 2
            right.onNext("right Vienna")
            left.onNext("left Lisbon")
            right.onNext("right Copenhagen")
            left.onNext("left London")
            left.onNext("left Madrid")
            right.onNext("right Vienna")
        }
        
        ///动态设置当前被订阅的序列
        _example(name: "switchLatest") {
            let one = PublishSubject<String>()
            let two = PublishSubject<String>()
            let three = PublishSubject<String>()
            
            let source = PublishSubject<Observable<String>>()
            
            ///switchLatest 可以在多个序列之间切换,动态的改变观察者观察的序列
            
            let observable = source.switchLatest()
            observable
                .debug("switchLatest")
                .subscribe()
                .disposed(by: disposeBag)
            
            source.onNext(one)
            one.onNext("Some text from sequence one") //printed
            two.onNext("Some text from sequence two")
            
            source.onNext(two)
            two.onNext("More text from sequence two")  //printed
            one.onNext("and also from sequence one")
            
            source.onNext(three)
            two.onNext("Why don't you see me?")
            one.onNext("I'm alone, help me")
            three.onNext("Hey it's three. I win.")  //printed
            
            source.onNext(one)
            one.onNext("Nope. It's me, one!") //printed
        }
        
        ///遍历序列的所有元素,对每个元素都应用同一个算法,遍历完成后然后将计算的结果作为元素发送出去
        _example(name: "reduce") {
            
            /// reduce 只会对完成的序列才有效果
            let source = Observable.of(1,2,3)
            let observable = source.reduce(0) { (summary, value) -> Int in
                return summary + value
            }
            observable.debug("reduce").subscribe().disposed(by: disposeBag)

        }
        
        ///遍历序列的所有元素,对每个元素都应用同一个算法,将计算的结果发送出去
        _example(name: "scan") {
            let source = Observable.of(1, 3, 5, 7, 9)
            let observable = source.scan(0, accumulator: +)
            observable
                .debug("scan")
                .subscribe()
                .disposed(by: disposeBag)
            
            
        }
        
        _example(name: "Challenge 1: The zip case") {
            /*
             
             Take the code from the scan(_:accumulator:) example above and improve it so as to display both the current value and the running total at the same time.
             */
            let source = Observable.of(2,4,6,8,10)
            let scan = source.scan(0, accumulator: +)
           
            debugPrint()
            debugPrint("1. using zip")
            let zipObservable = Observable.zip(source, scan) {
                (v1,v2) in
                return (v1,v2)
            }
            
            zipObservable
                .debug("zipObservable")
                .subscribe()
                .disposed(by: disposeBag)
            
            debugPrint()
            debugPrint("2. using enumerated , combineLatest, filter ,map together")
            let combineObservable = Observable.combineLatest(source.enumerated(), scan.enumerated()) {
                (v1,v2) in
                return (v1,v2)
            }
            .filter { return $0.index == $1.index }
            .map { return ($0.element,$1.element) }
            
            combineObservable
                .debug("combineObservable")
                .subscribe()
                .disposed(by: disposeBag)
        }
    }
}
