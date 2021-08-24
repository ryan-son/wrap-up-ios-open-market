//
//  EndPoint.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/08/24.
//

import Foundation

enum EndPoint {

    case items(page: Int)

    private static let scheme: String = "https://"
    private static let host: String = "camp-open-market-2.herokuapp.com/"
    private static let itemsURI: String = "items/"

    var path: String {
        switch self {
        case .items(let page):
            return EndPoint.scheme + EndPoint.host + EndPoint.itemsURI + "\(page)"
        }
    }
}
