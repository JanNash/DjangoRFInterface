//
//  Node.swift
//  DjangoConsumer
//
//  Created by Jan Nash (privat) on 18.01.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


// MARK: // Public
// MARK: Protocol Declaration
public protocol Node {
    // Basic Setup
    var baseURL: URL { get }
    
    // Alamofire SessionManager
    // In OAuth2Node, the adapter and retrier variables of this sessionManager
    // should not be changed, since an OAuth2Node sets an OAuth2Handler as
    // its adapter and retrier.
    var sessionManager: SessionManager { get }
    
    // Filtering
    func defaultFilters(for objectType: FilteredListGettable.Type) -> [FilterType]
    
    // Parameter Generation
    func parametersFrom(offset: UInt, limit: UInt, filters: [FilterType]) -> Parameters
    func parametersFrom(offset: UInt, limit: UInt) -> Parameters
    func parametersFrom(filters: [FilterType]) -> Parameters
    
    // List GET Request and Response Helpers
    func defaultLimit<T: ListGettable>(for resourceType: T.Type) -> UInt
    func paginationType<T: ListGettable>(for resourceType: T.Type) -> Pagination.Type
    func relativeListURL<T: ListGettable>(for resourceType: T.Type) -> URL
    func absoluteListURL<T: ListGettable>(for resourceType: T.Type) -> URL
    func extractListResponse<T: ListGettable>(for resourceType: T.Type, from json: JSON) -> (Pagination, [T])
    
    // Detail Request and Response Helpers
    func relativeDetailURL<T: DetailResource>(for resource: T, with method: HTTPMethod) -> URL
    func absoluteDetailURL<T: DetailResource>(for resource: T, with method: HTTPMethod) -> URL
}


// MARK: DefaultListResponseKeys
public struct DefaultListResponseKeys {
    public static let meta: String = "meta"
    public static let results: String = "results"
}


// MARK: Default Implementations
// MARK: Filtering
public extension Node {
    func defaultFilters(for objectType: FilteredListGettable.Type) -> [FilterType] {
        return []
    }
}


// MARK: Parameter Generation
public extension Node {
    func parametersFrom(offset: UInt, limit: UInt, filters: [FilterType] = []) -> Parameters {
        return self._parametersFrom(offset: offset, limit: limit, filters: filters)
    }
    
    func parametersFrom(offset: UInt, limit: UInt) -> Parameters {
        return self._parametersFrom(offset: offset, limit: limit)
    }
    
    func parametersFrom(filters: [FilterType]) -> Parameters {
        return filters.reduce(into: [:], { $0[$1.stringKey] = $1.value })
    }
}


// MARK: List GET Request and Response Helpers
public extension Node {
    func paginationType<T>(for resourceType: T.Type) -> Pagination.Type where T : ListGettable {
        return DefaultPagination.self
    }
    
    func absoluteListURL<T: ListGettable>(for resourceType: T.Type) -> URL {
        return self._absoluteListURL(for: resourceType)
    }
    
    func extractListResponse<T: ListGettable>(for resourceType: T.Type, from json: JSON) -> (Pagination, [T]) {
        return self._extractListResponse(for: resourceType, from: json)
    }
}


// MARK: Detail Request and Response Helpers
public extension Node {
    func relativeDetailURL<T: DetailResource>(for resource: T, with method: HTTPMethod) -> URL {
        return resource.detailURI.url
    }
    
    func absoluteDetailURL<T: DetailResource>(for resource: T, with method: HTTPMethod) -> URL {
        let detailURL: URL = self.relativeDetailURL(for: resource, with: method)
        return self.baseURL.appendingPathComponent(detailURL.absoluteString)
    }
}


// MARK: // Private
// MARK: Parameter Generation Implementation
private extension Node {
    func _parametersFrom(offset: UInt, limit: UInt, filters: [FilterType] = []) -> Parameters {
        var parameters: Parameters = [:]
        let writeToParameters: (String, Any) -> Void = { parameters[$0] = $1 }
        self.parametersFrom(offset: offset, limit: limit).forEach(writeToParameters)
        self.parametersFrom(filters: filters).forEach(writeToParameters)
        return parameters
    }
    
    func _parametersFrom(offset: UInt, limit: UInt) -> Parameters {
        return [
            DefaultPagination.Keys.offset: offset,
            DefaultPagination.Keys.limit: limit
        ]
    }
}


// MARK: List Request and Response Helper Implementations
private extension Node {
    func _absoluteListURL<T: ListGettable>(for resourceType: T.Type) -> URL {
        let relativeURL: URL = self.relativeListURL(for: resourceType)
        return self.baseURL.appendingPathComponent(relativeURL.absoluteString)
    }
    
    func _extractListResponse<T: ListGettable>(for resourceType: T.Type, from json: JSON) -> (Pagination, [T]) {
        let paginationType: Pagination.Type = self.paginationType(for: resourceType)
        let pagination: Pagination = paginationType.init(json: json[DefaultListResponseKeys.meta])
        let objects: [T] = json[DefaultListResponseKeys.results].array!.map(T.init)
        return (pagination, objects)
    }
}

