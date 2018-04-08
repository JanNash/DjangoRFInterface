//
//  JSONResponseHandlingTests.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 08.04.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import XCTest
import Alamofire
import SwiftyJSON
import Alamofire_SwiftyJSON
@testable import DjangoConsumer


// MARK: // Internal
class JSONResponseHandlingTests: BaseTest {
    func testInitOnSuccessCorrectlyStored() {
        let expectation: XCTestExpectation = self.expectation(
            description: "Expected onSuccess closure that was passed into init to be called"
        )
        
        let responseHandling: JSONResponseHandling = JSONResponseHandling(
            onSuccess: { _ in expectation.fulfill() },
            onFailure: { _ in XCTFail("onFailure closure that was passed into init shouldn't be called") }
        )
        
        responseHandling.onSuccess(JSON())
        
        self.waitForExpectations(timeout: 10)
    }
    
    func testInitOnFailureCorrectlyStored() {
        let expectation: XCTestExpectation = self.expectation(
            description: "Expected onFailure closure that was passed into init to be called"
        )
        
        let responseHandling: JSONResponseHandling = JSONResponseHandling(
            onSuccess: { _ in XCTFail("onSuccess closure that was passed into init shouldn't be called") },
            onFailure: { _ in expectation.fulfill() }
        )
        
        responseHandling.onFailure(MockError.foo)
        
        self.waitForExpectations(timeout: 10)
    }
    
    func testHandleSuccessResponse() {
        let expectation: XCTestExpectation = self.expectation(
            description: "Expected onSuccess closure that was passed into init to be called"
        )
        
        let expectedJSON: JSON = JSON(["foo" : "bar"])
        
        let responseHandling: JSONResponseHandling = JSONResponseHandling(
            onSuccess: { json in
                XCTAssertEqual(json, expectedJSON)
                expectation.fulfill()
            },
            onFailure: { _ in XCTFail("onFailure closure that was passed into init shouldn't be called") }
        )
        
        let mockResponse: DataResponse<JSON> = DataResponse(request: nil, response: nil, data: nil, result: .success(expectedJSON))
        
        responseHandling.handleResponse(mockResponse)
        
        self.waitForExpectations(timeout: 10)
    }
    
    func testHandleFailureResponse() {
        
    }
}
