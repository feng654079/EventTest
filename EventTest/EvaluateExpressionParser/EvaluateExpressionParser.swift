//
//  EvaluateExpressionParser.swift
//  EventTest
//
//  Created by apple on 2021/1/27.
//  Copyright © 2021 apple. All rights reserved.
//

import Foundation

extension String {
    
    var intValue:Int?  {
        return Int(self)
    }
    
    var operatorValue:String? {
        if self == "+" ||
           self == "-" ||
           self == "*" ||
           self == "/"
            {
                return self
            }
        return nil
    }
    
    var leftbracket:String? {
        if self == "(" {
            return self
        }
        return nil
    }
    
    var rightbraket:String? {
        if self == ")" {
            return self
        }
        return nil
    }
    
    func isHighPriotity(than op:String?) -> Bool {
        if op == nil { return true }
        let selfOP = self.operatorValue
        return (selfOP == "*" || selfOP == "/") && (op == "+" || op == "-" )
    }
}



//MARK: -
class EvaluateExpressionParser {
    
    enum State {
        case num
        case `operator`
        case leftbracket
        case rightbacket
        case none
    }
    
   private var state:State = .none
   private var tokens:[String] = []

    func parse(expression:String) {
        guard expression.count > 0 else {
            return
        }
        state = .none
        
        var p = expression.startIndex
        var q = p
        while  q != expression.endIndex {
            let c = String(expression[q])
            
            //处理数字
            if let intValue = c.intValue {
                state = .num
                var num = intValue
                q = expression.index(after: q)
                while  q != expression.endIndex ,
                       let c = String(expression[q]).intValue
                        {
                   num = (num * 10) + c
                   q = expression.index(after: q)
                }
                tokens.append("\(num)")
            }
            
            //操作符
            else if let op = c.operatorValue {
                state = .operator
                tokens.append(op)
                q = expression.index(after: q)
            }
            
            //左括号
            else if let lb = c.leftbracket {
                state = .leftbracket
                tokens.append(lb)
                q = expression.index(after: q)
            }
            
            //右括号
            else if let rb = c.rightbraket {
                state = .rightbacket
                tokens.append(rb)
                q = expression.index(after: q)
            }
            
            //其它字符默认不做处理
            else {
                q = expression.index(after: q)
            }
            p = q
        }
    }
    
    func getTokens() -> [String] {
        return tokens
    }
    
    ///从中缀表达式转换到后缀表达式
    ///https://blog.csdn.net/dream_1996/article/details/78126839
    func infixExpressToPostfixExpress() -> [String]  {
        var postfixQueue:[String] = []
        var opStack:[String] = []
        for i in tokens {
        
            if let _ = i.intValue {
                postfixQueue.append(i)
            }
            
            else if let op = i.operatorValue {
                if var topOp = opStack.last {
                    ///循环把优先级高于当前的运算符出栈加入到后缀队列
                    while
                        topOp.operatorValue != nil &&
                        op.isHighPriotity(than: topOp.operatorValue) == false &&
                            opStack.count > 0 {
                        postfixQueue.append(topOp)
                        opStack.removeLast()
                        if let l = opStack.last {
                            topOp = l
                        }
                    }
                    opStack.append(op)
                }
                else {
                    ///第一个操作符直接入栈
                    opStack.append(op)
                }
            }
            
            else if let lb = i.leftbracket {
                opStack.append(lb)
            }
            
            else if let _ = i.rightbraket {
                if var topOp = opStack.last {
                    while topOp != "(" && opStack.count > 0 {
                        postfixQueue.append(topOp)
                        opStack.removeLast()
                        if let l = opStack.last {
                            topOp = l
                        }
                    }
                    //remove "("
                    opStack.removeLast()
                }
            }
        }
        
        //将剩余操作符一次出栈入栈
        if opStack.count > 0 {
            postfixQueue.append(contentsOf: opStack.reversed())
        }
        return postfixQueue
    }
    
    
    var result: Int? {
        ///使用tokens 获取后缀表达式
        let postfixExpress = infixExpressToPostfixExpress()
        var stack:[Int] = []
        ///遍历后缀表达式计算 
        for i in postfixExpress {
            if let intValue = i.intValue {
                stack.append(intValue)
            }
            else if let op = i.operatorValue {
                guard stack.count > 0 else { return nil }
                let first = stack[stack.count - 2]
                let second = stack[stack.count - 1]
                guard let result = performOperater(a: first, b: second, op: op) else {
                    return nil
                }
                stack.removeLast(2)
                stack.append(result)
            }
        }
        
        if stack.count ==  1 {
            return stack.first!
        }
        return nil
    }
    
    private func performOperater(a:Int,b:Int,op:String) -> Int? {
        if op == "+" {
            return a + b
        }
        else if op == "-" {
            return a - b
        }
        else if op == "*" {
            return a * b
        }
        else if op == "/" {
            return a / b
        }
        return nil
    }
}
