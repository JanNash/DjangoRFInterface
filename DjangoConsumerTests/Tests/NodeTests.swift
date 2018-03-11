//
//  NodeTests.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 11.03.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import XCTest
import Alamofire
import DjangoConsumer


// MARK: // Internal
class NodeTests: BaseTest {
    func testDefaultFilters() {
        let node: Node = MockNode()
        XCTAssert(node.defaultFilters(for: MockFilteredListGettable.self).isEmpty)
    }
    
    func testParametersFromOffsetLimitAndFilters() {
        let node: Node = MockNode()
        let expectedOffset: UInt = 10
        let expectedLimit: UInt = 100
        let nameFilter: _F<String> = _F(.name, .__icontains, "blubb")
        let filters = [nameFilter]
        
        let parameters: Parameters = node.parametersFrom(offset: expectedOffset, limit: expectedLimit, filters: filters)
        
        XCTAssert(parameters.count == 3)
        XCTAssertEqual(parameters[DefaultPagination.Keys.offset] as? UInt, expectedOffset)
        XCTAssertEqual(parameters[DefaultPagination.Keys.limit] as? UInt, expectedLimit)
        XCTAssertEqual(parameters[nameFilter.stringKey] as? String, nameFilter.value as? String)
    }
}
