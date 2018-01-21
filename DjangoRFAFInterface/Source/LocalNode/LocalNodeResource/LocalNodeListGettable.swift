//
//  LocalNodeListGettable.swift
//  DjangoRFAFInterface
//
//  Created by Jan Nash (privat) on 19.01.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation
import Alamofire


// MARK: // Public
public protocol LocalNodeListGettable: DRFListGettable {
    static var localNodeMaximumLimit: UInt { get }
    static var allFixtureObjects: [Self] { get }
    static func filterClosure(for queryParameters: Parameters) -> ((Self) -> Bool)
    func toJSONDict() -> [String : Any]
}
