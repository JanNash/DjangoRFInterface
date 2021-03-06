//
//  Payload.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 27.06.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation


// MARK: // Public
// MARK: - UnwrappedPayload Equatability
public func == (_ lhs: Payload.Multipart.UnwrappedPayload, _ rhs: Payload.Multipart.UnwrappedPayload) -> Bool {
    return __eq__(lhs, rhs)
}


public func == (_ lhs: Payload.JSON.UnwrappedPayload, _ rhs: Payload.JSON.UnwrappedPayload) -> Bool {
    return __eq__(lhs, rhs)
}


// MARK: -
// MARK: Interface
public extension Payload {
    mutating func merge(_ json: JSON.Dict, conversion: PayloadConversion) {
        self.merge(json._dict, conversion: conversion)
    }
    
    mutating func merge(_ multipart: Multipart.Dict, conversion: PayloadConversion) {
        self.merge(multipart._dict, conversion: conversion)
    }
    
    mutating func merge(_ dict: [String: PayloadElementConvertible], conversion: PayloadConversion) {
        self._merge(dict, conversion: conversion)
    }
    
    func merging(_ json: JSON.Dict, conversion: PayloadConversion) -> Payload {
        return self.merging(json._dict, conversion: conversion)
    }
    
    func merging(_ multipart: Multipart.Dict, conversion: PayloadConversion) -> Payload {
        return self.merging(multipart._dict, conversion: conversion)
    }
    
    func merging(_ dict: [String: PayloadElementConvertible], conversion: PayloadConversion) -> Payload {
        return self._merging(dict, conversion: conversion)
    }
}


// MARK: -
public struct Payload: Equatable {
    // Internal Init
    internal init(_rootObject: PayloadConvertible?, _method: ResourceHTTPMethod, _json: JSON.UnwrappedPayload, _multipart: Multipart.UnwrappedPayload) {
        self.rootObject = _rootObject
        self.method = _method
        self.json = _json
        self.multipart = _multipart
    }
    
    // Constants
    public let rootObject: PayloadConvertible?
    public let method: ResourceHTTPMethod
    
    // Variables
    public private(set) var json: JSON.UnwrappedPayload = [:]
    public private(set) var multipart: Multipart.UnwrappedPayload = [:]
    
    // Equatable Conformance
    public static func == (lhs: Payload, rhs: Payload) -> Bool {
        // ???: Should rootObject and method be taken into account as well?
        return lhs.json == rhs.json && lhs.multipart == rhs.multipart
    }
    
    // JSONData
    public func jsonData() -> Data {
        return try! JSONSerialization.data(withJSONObject: self.json)
    }
    
    // Element
    public typealias Element = (json: JSON.UnwrappedPayload?, multipart: Multipart.UnwrappedPayload?)
    
    // Dict
    public struct Dict: Collection, ExpressibleByDictionaryLiteral, PayloadElementConvertible {
        // Typealiases
        public typealias DictType = [String: PayloadElementConvertible]
        public typealias MergeStrategy = DictType.MergeStrategy
        
        // Collection Typealiases
        public typealias Index = DictType.Index
        public typealias Key = DictType.Key
        public typealias Value = DictType.Value
        public typealias Element = (key: Key, value: Value)
        
        // Init
        public init(_ dict: [String: PayloadElementConvertible]) {
            self._dict = dict
        }
        
        // ExpressibleByDictionaryLiteral Init
        public init(dictionaryLiteral elements: (Key, Value)...) {
            self._dict = Dictionary(elements, strategy: .overwriteOldValue)
        }
        
        // Private Variables
        fileprivate var _dict: DictType
    }
    
    // JSON
    public enum JSON {
        // UnwrappedPayload
        public typealias UnwrappedPayload = [String: Any]
        
        // Typed Value
        public enum Value: Equatable, CustomStringConvertible, JSONValueConvertible {
            case bool(Bool?)
            case int(Int?)
            case int8(Int8?)
            case int16(Int16?)
            case int32(Int32?)
            case int64(Int64?)
            case uInt(UInt?)
            case uInt8(UInt8?)
            case uInt16(UInt16?)
            case uInt32(UInt32?)
            case uInt64(UInt64?)
            case float(Float?)
            case double(Double?)
            case string(String?)
            // Collections
            case array([Value])
            case dict([String: Value])
            // Null
            // TODO: Document when and how null is used
            case null
            
            public func toJSONValue() -> Payload.JSON.Value {
                return self
            }
        }
    
        // Dict
        public struct Dict: Collection, Equatable, ExpressibleByDictionaryLiteral, JSONValueConvertible {
            // Typealiases
            public typealias DictType = [String: JSONValueConvertible]
            public typealias MergeStrategy = DictType.MergeStrategy
            
            // Collection Typealiases
            public typealias Index = DictType.Index
            public typealias Key = DictType.Key
            public typealias Value = DictType.Value
            public typealias Element = (key: Key, value: Value)
            
            // Init
            public init(_ dictionary: [Key: Value]) {
                self._dict = dictionary
            }
            
            // ExpressibleByDictionaryLiteral Init
            public init(dictionaryLiteral elements: (Key, Value)...) {
                self._dict = Dictionary(elements, strategy: .overwriteOldValue)
            }
            
            // Fileprivate Variables
            fileprivate var _dict: DictType
            
            // Equatable Conformance
            public static func == (lhs: Payload.JSON.Dict, rhs: Payload.JSON.Dict) -> Bool {
                return lhs.toJSONValue() == rhs.toJSONValue()
            }
            
            // JSONValueConvertible Conformance
            public func toJSONValue() -> JSON.Value {
                return .dict(self._dict.mapToDict({ ($0, $1.toJSONValue()) }, strategy: .overwriteOldValue))
            }
            
            // Unwrap
            public func unwrap() -> JSON.UnwrappedPayload {
                return self._dict.mapToDict({ ($0, $1.toJSONValue().unwrap()) }, strategy: .overwriteOldValue)
            }
        }
    }
    
    public enum Multipart {
        // UnwrappedPayload
        public typealias UnwrappedPayload = [String: Value]
        
        // Value
        public typealias Value = (Data, ContentType)
        
        // Path
        public struct Path {
            // Element
            public enum Element {
                case key(String)
                case index(Int)
            }
            
            // Public Init
            public init(_ key: String) {
                self.head = key
            }
            
            // Private Init
            private init(head: String, tail: [Element]) {
                self.head = head
                self.tail = tail
            }
            
            // Public ReadOnly Variables
            public private(set) var head: String
            public private(set) var tail: [Element] = []
            
            // Appending
            public static func + (_ lhs: Path, _ rhs: Path.Element) -> Path {
                return Path(head: lhs.head, tail: lhs.tail + [rhs])
            }
        }
        
        // JSONKey
        public static let jsonKey: String = "data"
        
        // ContentType
        public enum ContentType: String, CustomStringConvertible, Equatable, CaseIterable {
            case applicationJSON = "application/json"
            case imageJPEG = "image/jpeg"
            case imagePNG = "image/png"
            // TODO: Add missing content types
            
            // null
            var null: Value {
                return ("null".data(using: .utf8)!, self)
            }
            
            // CustomStringConvertible
            public var description: String {
                return self.rawValue
            }
        }
        
        // Dict
        public struct Dict: Collection, ExpressibleByDictionaryLiteral {
            // Typealiases
            public typealias DictType = [String: MultipartValueConvertible]
            public typealias MergeStrategy = DictType.MergeStrategy
            
            // Collection Typealiases
            public typealias Index = DictType.Index
            public typealias Key = DictType.Key
            public typealias Value = DictType.Value
            public typealias Element = (key: Key, value: Value)
            
            // Init
            public init(_ dictionary: [Key: Value]) {
                self._dict = dictionary
            }
            
            // ExpressibleByDictionaryLiteral Init
            public init(dictionaryLiteral elements: (Key, Value)...) {
                self._dict = Dictionary(elements, strategy: .overwriteOldValue)
            }
            
            // Private Variables
            fileprivate var _dict: DictType
        }
    }
}


// MARK: Payload.Dict: Collection
extension Payload.Dict/*: Collection*/ {
    public var startIndex: Index {
        return self._dict.startIndex
    }
    
    public var endIndex: Index {
        return self._dict.endIndex
    }
    
    public func index(after i: Index) -> Index {
        return self._dict.index(after: i)
    }
    
    public subscript(key: Key) -> Value? {
        get { return self._dict[key] }
        set { self._dict[key] = newValue }
    }
    
    public subscript(position: Index) -> (key: Key, value: Value) {
        return self._dict[position]
    }
}


// MARK: Payload.JSON.Dict: Collection
extension Payload.JSON.Dict/*: Collection*/ {
    public var startIndex: Index {
        return self._dict.startIndex
    }
    
    public var endIndex: Index {
        return self._dict.endIndex
    }
    
    public func index(after i: Index) -> Index {
        return self._dict.index(after: i)
    }
    
    public subscript(key: Key) -> Value? {
        get { return self._dict[key] }
        set { self._dict[key] = newValue }
    }
    
    public subscript(position: Index) -> (key: Key, value: Value) {
        return self._dict[position]
    }
}


// MARK: Payload.Multipart.Dict: Collection
extension Payload.Multipart.Dict/*: Collection*/ {
    public var startIndex: Index {
        return self._dict.startIndex
    }
    
    public var endIndex: Index {
        return self._dict.endIndex
    }
    
    public func index(after i: Index) -> Index {
        return self._dict.index(after: i)
    }
    
    public subscript(key: Key) -> Value? {
        get { return self._dict[key] }
        set { self._dict[key] = newValue }
    }
    
    public subscript(position: Index) -> (key: Key, value: Value) {
        return self._dict[position]
    }
}


// MARK: // Private
// MARK: Interface Implementation
private extension Payload {
    mutating func _merge(_ dict: [String: PayloadElementConvertible], conversion: PayloadConversion) {
        let payload: Payload = Payload.Dict(dict).toPayload(
            conversion: conversion, rootObject: self.rootObject, method: self.method
        )
        self.json.merge(payload.json, strategy: .overwriteOldValue)
        self.multipart.merge(payload.multipart, strategy: .overwriteOldValue)
    }
    
    func _merging(_ dict: [String: PayloadElementConvertible], conversion: PayloadConversion) -> Payload {
        var payload: Payload = self
        payload.merge(dict, conversion: conversion)
        return payload
    }
}


// MARK: Equatable Implementations
// MARK: - Payload.Multipart.UnwrappedPayload
private func __eq__(_ lhs: Payload.Multipart.UnwrappedPayload, _ rhs: Payload.Multipart.UnwrappedPayload) -> Bool {
    guard lhs.count == rhs.count else {
        return false
    }
    
    for (key, lValue) in lhs {
        guard
            let rValue: Payload.Multipart.Value = rhs[key],
            lValue == rValue
        else { return false }
    }
    
    return true
}


// MARK: - Payload.JSON.UnwrappedPayload
private typealias _JSON = Payload.JSON.UnwrappedPayload
private func __eq__(_ lhs: _JSON, _ rhs: _JSON) -> Bool {
    guard lhs.count == rhs.count else {
        return false
    }
    
    for (key, lValue) in lhs {
        guard let rValue: Any = rhs[key] else {
            return false
        }
        
        // If the value is another [String: Any] dict, we can recurse
        if let lDict: _JSON = lValue as? _JSON {
            guard let rDict: _JSON = rValue as? _JSON else {
                return false
            }
            
            return lDict == rDict
        }
        
        // If the value is an Array of [String: Any] dicts, we can recurse iteratively
        if let lArray: [_JSON] = lValue as? [_JSON] {
            guard let rArray: [_JSON] = rValue as? [_JSON] else {
                return false
            }
            
            for (lElement, rElement) in zip(lArray, rArray) {
                guard lElement == rElement else {
                    return false
                }
            }
            
            return true
        }
        
        // If we get here, the value does not contain any more dicts, so we can safely
        // compare their String interpolations without having to worry about the unsafe
        // ordering of dicts, which obviously breaks this comparison method.
        guard "\(lValue)" == "\(rValue)" else {
            return false
        }
    }
    
    return true
}
