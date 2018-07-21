//
//  JSONValueConvertible.swift
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
// MARK: -
public protocol JSONValueConvertible: PayloadElementConvertible {
    func toJSONValue() -> Payload.JSON.Value
}


// MARK: PayloadValueConvertible Default Implementation
public extension JSONValueConvertible {
    public func toPayloadElement(conversion: PayloadConversion, configuration: PayloadConversion.Configuration) -> Payload.Element {
        return DefaultImplementations.JSONValueConvertible.payloadElement(from: self, conversion: (conversion, configuration))
    }
}


// MARK: - DefaultImplementations.JSONValueConvertible
public extension DefaultImplementations.JSONValueConvertible {
    public static func payloadElement(from jsonValueConvertible: JSONValueConvertible, conversion: (PayloadConversion, PayloadConversion.Configuration)) -> Payload.Element {
        return self._payloadElement(from: jsonValueConvertible, conversion: conversion)
    }
}


// MARK: // Private
private extension DefaultImplementations.JSONValueConvertible {
    private static func _payloadElement(from jsonValueConvertible: JSONValueConvertible, conversion: (PayloadConversion, PayloadConversion.Configuration)) -> Payload.Element {
        let (conversion, configuration): (PayloadConversion, PayloadConversion.Configuration) = conversion
        let jsonValue: Payload.JSON.Value =
            conversion.convert(jsonValueConvertible, configuration: configuration) ?? jsonValueConvertible.toJSONValue()
        
        return ([configuration.currentKey: jsonValue.unwrap()], nil)
    }
}
