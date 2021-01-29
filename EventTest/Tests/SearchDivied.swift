//
//  SearchDivied.swift
//  EventTest
//
//  Created by apple on 2020/9/27.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

extension ViewController {
    
    /// 使用分治法查询有序数组中元素
    /// - Parameters:
    ///   - sortedArr: 被查询的有序数组
    ///   - item: 被查找的值
    /// - Returns: 返回被查找元素的索引,如果没有找到则返回nil
    func findIndex(for sortedArr:[Int] ,for item:Int) -> Int?  {
        
        guard sortedArr.count > 0 else { return nil }
        
        var start = sortedArr.startIndex
        var end = sortedArr.endIndex - 1
        var middle = (start + end) / 2
        
        var count = 0
        
        if sortedArr[start] == item {
            debugPrint("循环次数:\(count)")
            return start
        }
        
        if sortedArr[end] == item {
            debugPrint("循环次数:\(count)")
            return end
        }
        
        
        while start != end {
            count += 1
            if sortedArr[middle] == item {
                debugPrint("循环次数:\(count)")
                return middle
            } else {
                if sortedArr[middle] > item {
                    let n = middle - 1
                    if n >= 0 {
                        end = n
                    }
                    
                    if sortedArr[end] == item {
                        debugPrint("循环次数:\(count)")
                        return end
                    }
                    
                } else if sortedArr[middle] < item {
                    let n = middle + 1
                    if n <= end {
                        start = n
                    }
                   
                    if sortedArr[start] == item {
                        debugPrint("循环次数:\(count)")
                        return start
                    }
                }
                middle = (start + end) / 2
            }
        }
        
        debugPrint("循环次数:\(count)")
        return nil
    }
}
