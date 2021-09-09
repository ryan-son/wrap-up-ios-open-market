//
//  URLRequest+Extensions.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/09/03.
//

import Foundation

extension URLRequest {

    init(url: URL, method: NetworkManager.UploadHTTPMethod, contentType: String, httpBody: Data) {
        self.init(url: url)
        self.httpMethod = method.rawValue.uppercased()
        self.setValue(contentType, forHTTPHeaderField: "Content-Type")
        self.httpBody = httpBody
    }
}
