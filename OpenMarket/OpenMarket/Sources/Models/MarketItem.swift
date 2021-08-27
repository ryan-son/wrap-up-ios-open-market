//
//  MarketItem.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/08/24.
//

import Foundation

struct MarketItem: Decodable {

    let id: Int
    let title: String
    let descriptions: String?
    let price: Int
    let currency: String
    let stock: Int
    let discountedPrice: Int?
    let thumbnails: [String]
    let images: [String]?
    let registrationDate: TimeInterval
}
