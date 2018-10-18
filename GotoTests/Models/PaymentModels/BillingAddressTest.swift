//
//  BillingAddressTest.swift
//  GotoTests
//
//  Created by Adrian Rusin on 1/17/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import XCTest
@testable import Goto

class BillingAddressTest: XCTestCase {
    var blillingAddress: BillingAddress!
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        blillingAddress = BillingAddress()
        blillingAddress.firstName = "Adrian"
        blillingAddress.lastName = "Rusin"
        blillingAddress.country = "PL"
        blillingAddress.email = "adrian09h@gmail.com"
        blillingAddress.zip = "10010"

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        blillingAddress = nil
    }
    func testBillingAddressModel() {
        let json = blillingAddress.getJSON()
        XCTAssert(json.count == 5, "BillingAddress class did not created json data correctly.")

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
