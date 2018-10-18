//
//  HelperTest.swift
//  GotoTests
//
//  Created by Adrian Rusin on 1/17/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import XCTest
@testable import Goto

class HelperTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    func testHelperMethods() {
        let validEmail = Helper.validateEmail(candidate: "adrian09h@gmail.com")
        XCTAssert(validEmail, "Email validation does not works correctly.")
        let strDate = Helper.convertStringFromDate(date: Date())
        XCTAssert(strDate.count > 0, "Convertion string from date method does not works correctly.")
        let date = Helper.convertStringToDate(date: "2018-01-12T10:16:04.878Z")
        XCTAssert(date != nil, "Convertion date from string method does not works correctly.")
    }
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
