//
//  Queue.swift
//  EventTest
//
//  Created by apple on 2020/12/17.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

public struct Queue<T> {
    fileprivate var array = [T?]()
    fileprivate var head = 0
    
    public var count: Int { 
        return array.count - head
    }
    
    public var isEmpty: Bool {
        return count == 0
    }
    
    public mutating func enqueue(_ element: T) {
        array.append(element)
    }
    
    public mutating func dequeue() -> T? {
        guard head < array.count,let element = array[head] else {
            return nil
        }
        array[head] = nil
        head += 1
        let percentage = Double(head) / Double(array.count)
        if array.count > 50 && percentage > 0.25 {
            array.removeFirst(head)
            head = 0
        }
        return element
    }
    
    public var front: T? {
        if isEmpty {
            return nil
        } else {
            return array[head]
        }
    }
}

//O(n^2)
struct InsertionSort {
    static func insertionSort
    (_ array:[Int])
    -> [Int]
    {
        var sortedArray = array
        for index in 1..<sortedArray.count {
            var nowIndex = index
            while
                nowIndex > 0,
                sortedArray[nowIndex] < sortedArray[nowIndex - 1]  {
                sortedArray.swapAt(nowIndex, nowIndex - 1)
                nowIndex -= 1
            }
        }
        return sortedArray
    }
    
    static func insertionSort2
    (_ array:[Int])
    -> [Int]
    {
        var sortedArray = array
        for index in 1..<sortedArray.count {
            var nowIndex = index
            let t = sortedArray[nowIndex]
            while
                nowIndex > 0 &&
                t < sortedArray[nowIndex - 1]  {
                sortedArray[nowIndex] = sortedArray[nowIndex - 1]
                nowIndex -= 1
            }
            sortedArray[nowIndex] = t
        }
        return sortedArray
    }
    
    static func insertionSort<T>
    (_ array:[T], _ isOrderBefore:(T,T) -> Bool)
    -> [T]
    {
        var sortedArray = array
        for index in 1..<sortedArray.count {
            var nowIndex = index
            let t = sortedArray[nowIndex]
            while
                nowIndex > 0 &&
                isOrderBefore(t,sortedArray[nowIndex - 1])  {
                sortedArray[nowIndex] = sortedArray[nowIndex - 1]
                nowIndex -= 1
            }
            sortedArray[nowIndex] = t
        }
        return sortedArray
    }
}

struct QuickSort {
    static func quickStort<T>
    (_ array: [T], by areInIncreasingOrder:(T,T) -> Bool)
    -> [T]
    {
        var sortedArr = array
        _quickSort(&sortedArr, left: 0, right: sortedArr.count - 1, by: areInIncreasingOrder)
        return sortedArr
    }
    
    private static func _quickSort<T>
    (_ array:inout [T],left: Int,right:Int, by areInIncreasingOrder:(T,T) -> Bool)
    {
        guard left < right,
              array.count > 0
              else {
            return
        }
        var l = left,r = right
        let base = array[left]
        while l != r {
            while r > l && areInIncreasingOrder(base,array[r]) {
                r -= 1
            }
            if (l < r) {
                array[l] = array[r]
                l += 1
            }
            while l < r && areInIncreasingOrder(array[l],base) {
                l += 1
            }
            if (l < r) {
                array[r] = array[l]
                r -= 1
            }
        }
        array[l] = base
        _quickSort(&array, left: left, right: l - 1, by: areInIncreasingOrder)
        _quickSort(&array, left: l + 1, right: right, by: areInIncreasingOrder)
        
    }
}

struct BinarySearch {
    ///使用递归
    static func search<T: Comparable>
    (_ sorted: [T],key: T,range: Range<Int>)
    -> Int?
    {
        guard range.lowerBound <= range.upperBound else {
            return nil
        }
        let midIndex = range.lowerBound + (range.upperBound - range.lowerBound) / 2
        if sorted[midIndex] > key {
           return search(sorted, key: key, range: range.lowerBound..<midIndex)
        } else if sorted[midIndex] > key {
           return search(sorted, key: key, range: midIndex + 1..<range.upperBound)
        }
        return midIndex
    }
    
    ///循环版本
    static func search2<T: Comparable>
    (_ sorted: [T],key: T)
    -> Int?
    {
        var low = 0
        var upper = sorted.count
        while low < upper {
            let mid = low + (upper - low) / 2
            if sorted[mid] < key {
                upper = mid
            } else if sorted[mid] > key {
                low = mid + 1
            }
            return mid
        }
        return nil
    }
}

///二叉搜索数(always sorted)
///插入和删除是均能保持有序
public class BinarySearchTree<T: Comparable> {
    private(set) public var value: T
    private(set) public weak var parent: BinarySearchTree?
    private(set) public var left: BinarySearchTree?
    private(set) public var right: BinarySearchTree?
    
    public init(value: T) {
        self.value = value
    }
    
    public convenience init(array: [T]) {
        precondition(array.count > 0)
        self.init(value:array.first!)
        for v in array.dropFirst() {
            insert(value: v)
        }
        
    }
    
    public var isRoot: Bool {
        return parent == nil
    }
    
    public var isLeaf: Bool {
        return left == nil && right == nil
    }
    
    public var isLeftChild: Bool {
        return parent?.left === self
    }
    
    public var isRightChild: Bool {
        return parent?.right === self
    }
    
    public var hasLeftChild: Bool {
        return left != nil
    }
    
    public var hasRightChild: Bool {
        return right != nil
    }
    
    public var hasAnyChild: Bool {
        return hasLeftChild || hasRightChild
    }
    
    public var hasBothChild: Bool {
        return hasLeftChild && hasRightChild
    }
    
    public var count: Int {
        return (left?.count ?? 0) + 1 + (right?.count ?? 0)
    }
    
    public func insert(value: T) {
        if value < self.value {
            if let left = self.left {
                left.insert(value: value)
            } else {
                left = BinarySearchTree(value: value)
                left?.parent = self
            }
        } else {
            if let right = self.right {
                right.insert(value: value)
            } else {
                right = BinarySearchTree(value: value)
                right?.parent  = self
            }
        }
    }
    
    public func search(value: T) -> BinarySearchTree? {
        if value < self.value {
            return left?.search(value: value)
        } else if value > self.value {
            return right?.search(value: value)
        }
        return self
    }
    
    public func search2(value: T) -> BinarySearchTree? {
        var p: BinarySearchTree? = self
        while p != nil  {
            if value < p!.value {
                p = p?.left
            } else if value > p!.value {
                p = p?.right
            } else {
                return p
            }
        }
        return nil
    }
    
    public func traverseInOrder(process: (T) -> Void) {
        left?.traverseInOrder(process: process)
        process(value)
        right?.traverseInOrder(process: process)
    }
    
    public func traversPreOrder(process: (T) -> Void) {
        process(value)
        left?.traverseInOrder(process: process)
        right?.traverseInOrder(process: process)
    }
    
    public func traversPostOrder(process: (T) -> Void) {
        left?.traverseInOrder(process: process)
        right?.traverseInOrder(process: process)
        process(value)
    }
    
    public func map(formula: (T) -> T)
    -> [T] {
        var a = [T]()
        if let left = left {
            a += left.map(formula: formula)
        }
        a.append(formula(value))
        if let right = right {
            a += right.map(formula: formula)
        }
        return a
    }
    
    public func toArray() -> [T] {
        return map { $0 }
    }
    
    public func minimum() -> BinarySearchTree {
        var node = self
        while let next = node.left {
            node = next
        }
        return node
    }
    
    public func maximum() -> BinarySearchTree {
        var node = self
        while let next = node.right {
            node = next
        }
        return node
    }
    
    @discardableResult
    public func remove() -> BinarySearchTree? {
        let replacement: BinarySearchTree?
        if let right = right {
            replacement = right.minimum()
        } else if let left = left {
            replacement = left.maximum()
        } else {
            replacement = nil
        }
        replacement?.remove()
        
        replacement?.right = right
        replacement?.left = left
        right?.parent = replacement
        left?.parent = replacement
        reconnectParentTo(node: replacement)
        
        parent = nil
        left = nil
        right = nil
        return replacement
    }
    
    public func height() -> Int {
        if isLeaf {
            return 0
        } else {
            return 1 + max(left?.height() ?? 0 , right?.height() ?? 0)
        }
    }
    
    public func depth() -> Int {
        var node = self
        var edges = 0
        while let parent = node.parent {
            node = parent
            edges += 1
        }
        return edges
    }
    
    public func predecessor() -> BinarySearchTree<T>? {
        if let left = left {
            return left.maximum()
        } else {
            var node = self
            while let parent = node.parent {
                if parent.value < value {
                    return parent
                }
                node = parent
            }
            return nil
        }
    }
    
    public func successor() -> BinarySearchTree<T>? {
        if let right = right {
            return right.minimum()
        } else {
            var node = self
            while let parent = node.parent {
                if parent.value > value {
                    return parent
                }
                node = parent
            }
        }
        return nil
    }
    
    public func isBST(minValue: T, maxValue:T) -> Bool {
        if value < minValue || value > maxValue {
            return false
        }
        let leftBST = left?.isBST(minValue: minValue, maxValue: value) ?? true
        let rightBST = right?.isBST(minValue: value, maxValue: maxValue) ?? true
        return leftBST && rightBST
    }
    
}

//helpers
extension BinarySearchTree {
    ///重新设置父节点的子树
    private func reconnectParentTo(node: BinarySearchTree?) {
        if let parent = parent {
            if isLeftChild {
                parent.left = node
            } else {
                parent.right = node
            }
        }
        node?.parent = parent
    }
}

extension BinarySearchTree: CustomStringConvertible {
    public var description: String {
        var s = ""
        if let left = left {
            s += "(\(left.description)) <- "
        }
        s += "\(value)"
        if let right = right {
            s += " -> (\(right.description))"
        }
        return s
    }
}
