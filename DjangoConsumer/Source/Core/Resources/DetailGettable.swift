//
//  DetailGettable.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 13.02.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD 3 Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation
import Alamofire
import SwiftyJSON
import Alamofire_SwiftyJSON


// MARK: // Public
// MARK: Protocol Declaration
public protocol DetailGettable: IdentifiableResource, JSONInitializable {
    func gotNewSelf(_ newSelf: Self, from: Node)
    func failedGettingNewSelf(from: Node, with error: Error)
    static var detailGettableClients: [DetailGettableClient] { get set }
}


// MARK: Default Implementations
// MARK: where Self: NeedsNoAuth
public extension DetailGettable where Self: NeedsNoAuth {
    func get(from node: Node = Self.defaultNode) {
        DefaultImplementations._DetailGettable_.get(self, from: node)
    }
}


// MARK: - DefaultImplementations._DetailGettable_
public extension DefaultImplementations._DetailGettable_ {
    public static func get<T: DetailGettable>(_ detailGettable: T, from node: Node) {
        self._get(detailGettable, from: node)
    }
}


// MARK: // Private
// MARK: GET function Implementation
private extension DefaultImplementations._DetailGettable_ {
    static func _get<T: DetailGettable>(_ detailGettable: T, from node: Node) {
        let method: ResourceHTTPMethod = .get
        let encoding: ParameterEncoding = URLEncoding.default
        
        func onFailure(_ error: Error) {
            T.detailGettableClients.forEach({ $0.failedGettingObject(for: detailGettable, from: node, with: error) })
            detailGettable.failedGettingNewSelf(from: node, with: error)
        }
        
        do {
            let url: URL = try node.absoluteURL(for: detailGettable, method: method)
            
            func onSuccess(_ json: JSON) {
                let newSelf: T = node.extractSingleObject(for: T.self, method: method, from: json)
                T.detailGettableClients.forEach({ $0.gotObject(newSelf, for: detailGettable, from: node)})
                detailGettable.gotNewSelf(newSelf, from: node)
            }
            
            node.sessionManager.fireJSONRequest(
                with: RequestConfiguration(url: url, method: method, encoding: encoding),
                responseHandling: JSONResponseHandling(onSuccess: onSuccess, onFailure: onFailure)
            )
        } catch {
            onFailure(error)
        }
    }
}
