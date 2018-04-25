//
//  SinglePostable.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 06.03.18.
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
public protocol SinglePostable: DetailResource, JSONInitializable, ParameterConvertible {
    static var singlePostableClients: [SinglePostableClient] { get set }
}


// MARK: Default Implementations
// MARK: where Self: NeedsNoAuth
public extension SinglePostable where Self: NeedsNoAuth {
    func post(to node: Node = Self.defaultNode) {
        DefaultImplementations._SinglePostable_.post(self, to: node, additionalHeaders: [:], additionalParameters: [:])
    }
}


// MARK: - DefaultImplementations._SinglePostable_
public extension DefaultImplementations._SinglePostable_ {
    public static func post<T: SinglePostable>(_ singlePostable: T, to node: Node, additionalHeaders: HTTPHeaders, additionalParameters: Parameters) {
        self._post(singlePostable, to: node, additionalHeaders: additionalHeaders, additionalParameters: additionalParameters)
    }
}


// MARK: // Private
private extension DefaultImplementations._SinglePostable_ {
    static func _post<T: SinglePostable>(_ singlePostable: T, to node: Node, additionalHeaders: HTTPHeaders, additionalParameters: Parameters) {
        let routeType: RouteType.Detail = .singlePOST
        let method: ResourceHTTPMethod = routeType.method
        let url: URL = node.absoluteURL(for: T.self, routeType: routeType)
        let parameters: Parameters = node
            .parametersFrom(object: singlePostable, method: method)
            .merging(additionalParameters, uniquingKeysWith: { _, r in r })
        
        let encoding: ParameterEncoding = JSONEncoding.default
        
        func onSuccess(_ json: JSON) {
            let responseObject: T = node.extractSingleObject(for: T.self, method: method, from: json)
            T.singlePostableClients.forEach({ $0.postedObject(singlePostable, responseObject: responseObject, to: node)})
        }
        
        func onFailure(_ error: Error) {
            T.singlePostableClients.forEach({ $0.failedPostingObject(singlePostable, to: node, with: error) })
        }
        
        node.sessionManager.fireJSONRequest(
            with: RequestConfiguration(url: url, method: method, parameters: parameters, encoding: encoding, headers: additionalHeaders),
            responseHandling: JSONResponseHandling(onSuccess: onSuccess, onFailure: onFailure)
        )
    }
}
