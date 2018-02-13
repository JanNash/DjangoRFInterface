//
//  MockNode.swift
//  DjangoRFAFInterfaceTests
//
//  Created by Jan Nash (privat) on 21.01.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation
import Alamofire
import DjangoConsumer


// MARK: // Internal
// MARK: Class Declaration
class MockNode: Node {
    // Singleton
    static let main: MockNode = MockNode()
    
    // Node Conformance
    // Basic Setup
    var baseURL: URL = URL(string: "http://localhost:8080")!
    
    // Alamofire SessionManager
    // This is copied from the SessionManager implementation
    let sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        return SessionManager(configuration: configuration)
    }()
    
    // Pagination
    func defaultLimit<T: ListGettable>(for resourceType: T.Type) -> UInt {
        return 1000
    }
    
    // List GET endpoints
    func relativeListURL<T: ListResource>(for resourceType: T.Type, method: HTTPMethod) -> URL {
        return self._relativeListURL(for: resourceType, method: method)
    }
}


// MARK: // Private
// MARK: Node Implementations
private extension MockNode {
    func _relativeListURL<T: ListResource>(for resourceType: T.Type, method: HTTPMethod) -> URL {
        // ???: Didn't get a switch to work properly, what is the right syntax?
        if resourceType == MockListGettable.self {
            return URL(string: "listgettables/")!
        } else if resourceType == MockFilteredListGettable.self {
            return URL(string: "filteredlistgettables/")!
        }
        // FIXME: Throw a real Error here?
        fatalError("[MockNode] No URL registered for '\(resourceType)'")
    }
}
