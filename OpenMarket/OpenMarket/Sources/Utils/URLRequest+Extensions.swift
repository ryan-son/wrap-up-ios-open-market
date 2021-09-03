//
//  URLRequest+Extensions.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/09/03.
//

import Foundation

extension URLRequest {

    enum ContentType: String {
        case multipart = "multipart/form-data"
        case json = "application/json"
    }

    init(url: URL, method: NetworkManager.UploadHTTPMethod, contentType: URLRequest.ContentType, httpBody: Data) {
        self.init(url: url)
        self.httpMethod = method.rawValue.uppercased()
        self.setValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
        self.httpBody = httpBody
    }
}
