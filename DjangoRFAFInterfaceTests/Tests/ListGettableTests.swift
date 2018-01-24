//
//  ListGettableTests.swift
//  DjangoRFAFInterfaceTests
//
//  Created by Jan Nash (privat) on 24.01.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import XCTest
import DjangoRFAFInterface


// MARK: // Internal
class ListGettableTest: BaseTest {
    // Variables
    var client: MockListGettableClient = MockListGettableClient()
    
    
    // Setup / Teardown Overrides
    override func setUp() {
        super.setUp()
        MockListGettable.clients.append(self.client)
    }
    
    override func tearDown() {
        MockListGettable.clients = []
        super.tearDown()
    }
}


// MARK: TestCases
extension ListGettableTest {
    func testGettingWithoutAnyParameters() {
        let expectation: XCTestExpectation = XCTestExpectation(
            description: "Expected to successfully get some objects"
        )
        
        let defaultLimit: UInt = MockListGettable.defaultNode.defaultLimit(for: MockListGettable.self)
        let backendMaximumLimit: UInt = BaseTest.backend.maximumPaginationLimit(for: MockListGettable.self)
        let calculatedLimit: UInt = min(defaultLimit, backendMaximumLimit)
        var objects: [MockListGettable] = BaseTest.backend.fixtures(for: MockListGettable.self)
        if calculatedLimit < objects.count {
            objects = Array(objects[0..<Int(calculatedLimit)])
        }
        
        self.client.gotObjects_ = {
            returnedObjects, success in
            
            guard let returnedCastObjects: [MockListGettable] = returnedObjects as? [MockListGettable] else {
                XCTFail("Wrong object type returned, expected '[MockListGettable]', got '\(type(of: returnedObjects))' instead")
                return
            }
            
            for (obj1, obj2) in zip(objects, returnedCastObjects) {
                XCTAssertEqual(obj1.id, obj2.id)
            }
            
            XCTAssertEqual(success.offset, 0)
            XCTAssertEqual(success.limit, defaultLimit)
            XCTAssertEqual(success.filters.count, 0)
            XCTAssertEqual(success.responsePagination.offset, 0)
            XCTAssertEqual(success.responsePagination.limit, calculatedLimit)
            
            expectation.fulfill()
        }
        
        self.client.failedGettingObjects_ = {
            XCTFail("Failed getting objects with failure: \($0)")
        }
        
        MockListGettable.get()
        
        self.wait(for: [expectation], timeout: 1)
    }
}
