//
//  SessionManagerType.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 07.03.18.
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
// MARK: - RequestConfiguration
public struct RequestConfiguration {
    public init(url: URL, method: HTTPMethod, parameters: Parameters = [:], encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders = [:], acceptableStatusCodes: [Int] = Array(200..<300), acceptableContentTypes: [String] = ["*/*"]) {
        self.url = url
        self.method = method
        self.parameters = parameters
        self.encoding = encoding
        self.headers = headers
        self.acceptableStatusCodes = acceptableStatusCodes
        self.acceptableContentTypes = acceptableContentTypes
    }
    
    public var url: URL
    public var method: HTTPMethod
    public var parameters: Parameters
    public var encoding: ParameterEncoding
    public var headers: HTTPHeaders
    public var acceptableStatusCodes: [Int]
    public var acceptableContentTypes: [String]
}


// MARK: - ResponseHandling
public struct JSONResponseHandling {
    // Inits
    public init() {}
    public init(onSuccess: @escaping (JSON) -> Void, onFailure: @escaping (Error) -> Void) {
        self.onSuccess = onSuccess
        self.onFailure = onFailure
    }
    
    // Public Variables
    public var onSuccess: (JSON) -> Void = { _ in }
    public var onFailure: (Error) -> Void = { _ in }
}


// MARK: - SessionManagerType
public protocol SessionManagerType {
    func request(with cfg: RequestConfiguration) -> DataRequest
    func handleJSONResponse(for request: DataRequest, responseHandling: JSONResponseHandling)
}
