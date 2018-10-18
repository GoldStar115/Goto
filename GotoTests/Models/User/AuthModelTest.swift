//
//  AuthModelTest.swift
//  GotoTests
//
//  Created by Adrian Rusin on 1/17/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import XCTest
@testable import Goto

class AuthModelTest: XCTestCase {
    var auth: AuthModel!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        auth = nil
    }
    func testAuthModel() {
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "AuthModelJSON", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
        if let jsonResult = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: AnyObject]
        {
            auth = AuthModel(data: jsonResult!)
        }
        XCTAssert(auth != nil, "Json data does not exist")
        XCTAssert(auth.expired != nil, "AuthModel class did not parsed correctly.")

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
