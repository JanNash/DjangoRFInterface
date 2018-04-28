//
//  ListGettableOAuth2.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 29.01.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD 3 Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//


// MARK: // Public
// MARK: - ListGettableOAuth2
// MARK: Protocol Declaration
public protocol ListGettableOAuth2: ListGettable {
    static var defaultOAuth2Node: OAuth2Node { get }
}


// MARK: Default Implementations
public extension ListGettableOAuth2 {
    static func get(from node: OAuth2Node = Self.defaultOAuth2Node, offset: UInt = 0, limit: UInt? = nil) {
        DefaultImplementations._ListGettable_.get(
            self, from: node, via: node.sessionManagerOAuth2, offset: offset, limit: limit, filters: []
        )
    }
}
