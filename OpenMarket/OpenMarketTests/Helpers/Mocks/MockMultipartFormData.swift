//
//  MockMultipartFormData.swift
//  OpenMarketTests
//
//  Created by Ryan-Son on 2021/09/04.
//

import Foundation
@testable import OpenMarket

final class MockMultipartFormData: MultipartFormDataEncodable {

    let boundary: String = ""
    let contentType: String = ""
    
    func encode(parameters: [String : Any?]) -> Data {
        return Data()
    }
}
