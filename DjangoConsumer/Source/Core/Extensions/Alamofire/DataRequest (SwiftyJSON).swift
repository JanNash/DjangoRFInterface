//
//  DataRequest (SwiftyJSON).swift
//  DjangoConsumer
//
//  Created by Jan Nash on 03.10.19.
//  Copyright © 2019 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//
// Before being refactored, this code was copied
// from hash: 64b4c1e710555061e50aad02e8795542fd0a5df5
// of fork: https://www.github.com/JanNash/Alamofire-SwiftyJSON
// of original repository: https://github.com/SwiftyJSON/Alamofire-SwiftyJSON
// The full license text as supplied in the LICENSE file (same commit hash)
// can be found at the bottom of this file.

import Alamofire
import SwiftyJSON


// MARK: // Public
extension DataRequest {
    @discardableResult
    public func responseSwiftyJSON(
        queue: DispatchQueue? = nil,
        options: JSONSerialization.ReadingOptions = .allowFragments,
        completionHandler: @escaping (DataResponse<JSON>) -> Void)
        -> Self
    {
        return response(
            queue: queue,
            responseSerializer: SwiftyJSONResponseSerializer(options: options),
            completionHandler: completionHandler
        )
    }
}



// The aforementioned full license text:
/*
The MIT License (MIT)

Copyright (c) 2014 SwiftyJSON

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/
