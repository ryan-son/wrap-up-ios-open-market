//
//  DummyMultipartFormData.swift
//  OpenMarketTests
//
//  Created by Ryan-Son on 2021/09/04.
//

import Foundation
@testable import OpenMarket

final class SpyMultipartFormData: MultipartFormDataEncodable {

    let boundary: String = ""
    let contentType: String = ""
    private(set) var encodeCallCount: Int = .zero
    
    func encode(parameters: [String : Any?]) -> Data {
        encodeCallCount += 1
        return Data()
    }
}
