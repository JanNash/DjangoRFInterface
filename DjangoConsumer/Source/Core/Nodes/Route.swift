//
//  Route.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 08.03.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD 3 Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation
import Alamofire
import SwiftyJSON


// MARK: // Public
// MARK: - RouteType
public enum RouteType: String {
    case detail = "detail"
    case list = "list"
}


// MARK: - Route
// MARK: Struct Declaration
public struct Route {
    // Private Init
    private init(_ resourceType: MetaResource.Type, _ routeType: RouteType, _ method: ResourceHTTPMethod, _ relativePath: String) {
        self.resourceType = resourceType
        self.routeType = routeType
        self.method = method
        self.relativeURL = URL(string: relativePath)!
    }
    
    // Public Variables
    public private(set) var resourceType: MetaResource.Type
    public private(set) var routeType: RouteType
    public private(set) var method: ResourceHTTPMethod
    public private(set) var relativeURL: URL
}


// MARK: Available Routes
// MARK: GET
public extension Route {
    public static func listGET<T>(_ t: T.Type, _ rel: String) -> Route where T: ListGettable {
        return Route(t, .list, .get, rel)
    }
    
    public static func detailGET<T>(_ t: T.Type, _ rel: String) -> Route where T: DetailGettable {
        return Route(t, .detail, .get, rel)
    }
}


// MARK: POST
public extension Route {
//    public static func listPOST<T>(_ t: T.Type, _ rel: String) -> Route where T: ListPostable {
//        return Route(t, .list, .post, rel)
//    }
    
    public static func singlePOST<T>(_ t: T.Type, _ rel: String) -> Route where T: SinglePostable {
        return Route(t, .detail, .post, rel)
    }
}


// MARK: PUT
//public extension Route {
//    public static func detailPUT<T>(_ t: T.Type, _ rel: String) -> Route where T: DetailPuttable {
//        return Route(t, .detail, .put, rel)
//    }
//}


// MARK: PATCH
//public extension Route {
//    public static func detailPATCH<T>(_ t: T.Type, _ rel: String) -> Route where T: DetailPatchable {
//        return Route(t, .detail, .patch, rel)
//    }
//}


// MARK: PATCH
//public extension Route {
//    public static func detailDELETE<T>(_ t: T.Type, _ rel: String) -> Route where T: DetailDeletable {
//        return Route(t, .detail, .delete, rel)
//    }
//}
