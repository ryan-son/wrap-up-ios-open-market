//
//  DummyMultipartFormData.swift
//  OpenMarketTests
//
//  Created by Ryan-Son on 2021/09/04.
//

import Foundation
@testable import OpenMarket

final class DummyMultipartFormData: MultipartFormDataEncodable {

    let boundary: String = ""
    let contentType: String = ""
    
    func encode(parameters: [String : Any?]) -> Data {
        return Data()
    }
}
