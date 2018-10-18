//
//  CardInfoTest.swift
//  GotoTests
//
//  Created by Adrian Rusin on 1/17/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import XCTest
@testable import Goto

class CardInfoTest: XCTestCase {
    var cardData: CardInfo!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        cardData = CardInfo()
        cardData.cardHolderName = "Adrian R"
        cardData.cardNumber = "4111111111111111"
        cardData.CVV = "122"
        cardData.expirationMonth = "10"
        cardData.expirationYear = "2020"
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        cardData = nil
    }
    func testCardInfoModel() {
        let json = cardData.getJSON()
        XCTAssert(json.count == 5, "CardInfo class did not created json data correctly.")
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
