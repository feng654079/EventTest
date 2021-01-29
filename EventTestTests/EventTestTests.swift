//
//  EventTestTests.swift
//  EventTestTests
//
//  Created by apple on 2020/9/8.
//  Copyright © 2020 apple. All rights reserved.
//

import XCTest
@testable import EventTest

class EventTestTests: XCTestCase {
    
    var formateCount = 1_0000

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

   
    func testDateFormateNormal() {
        self.measure {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            for _ in 0..<formateCount {
                let date = Date()
                _ = formatter.string(from: date)
            }
        }
    }
    
    func testDateFormateWithCached() {
        self.measure {
            for _ in 0..<formateCount {
                let date = Date()
                let formatter = DateFormatter.cachedDefaultFormatter
                _ = formatter.string(from: date)
            }
        }
    }
    
    func testDateFormatedWithoutCached() {
        self.measure {
            for _ in 0..<formateCount {
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                _ = formatter.string(from: date)
            }
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
