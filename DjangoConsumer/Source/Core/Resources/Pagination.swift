//
//  Pagination.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 18.01.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//

import Foundation
import SwiftyJSON


// MARK: // Public
// MARK: - Pagination
public protocol Pagination {
    init(json: JSON)
    
    var limit: UInt { get }
    var next: URL? { get }
    var offset: UInt { get }
    var previous: URL? { get }
    var totalCount: UInt { get }
}


// MARK: - DefaultPagination
public struct DefaultPagination: Pagination {
    // Keys
    public struct Keys {
        public static let limit: String = "limit"
        public static let next: String = "next"
        public static let offset: String = "offset"
        public static let previous: String = "previous"
        public static let totalCount: String = "total_count"
    }
    
    // Init
    public init(json: JSON) {
        // ???: There must be a better way than to force unwrap?
        // Is there a way to fail gracefully here? Should the function throw?
        self.limit = json[Keys.limit].uInt!
        self.next = json[Keys.next].url
        self.offset = json[Keys.offset].uInt!
        self.previous = json[Keys.previous].url
        self.totalCount = json[Keys.totalCount].uInt!
    }
    
    // Public Variables
    public var limit: UInt
    public var next: URL?
    public var offset: UInt
    public var previous: URL?
    public var totalCount: UInt
}
