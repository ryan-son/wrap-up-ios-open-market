//
//  PatchMarketItem.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/08/30.
//

import Foundation

struct PatchMarketItem: MultipartUploadable {

    let id: Int
    let title: String?
    let descriptions: String?
    let price: Int?
    let currency: String?
    let stock: Int?
    let discountedPrice: Int?
    let images: [URL]?
    let password: String

    init(from marketItem: MarketItem, images: [URL]? = nil, password: String) {
        self.id = marketItem.id
        self.title = marketItem.title
        self.descriptions = marketItem.descriptions
        self.price = marketItem.price
        self.currency = marketItem.currency
        self.stock = marketItem.stock
        self.discountedPrice = marketItem.discountedPrice
        self.images = images
        self.password = password
    }

    var asDictionary: [String: Any?] {
        [
            "id": self.id,
            "title": self.title,
            "descriptions": self.descriptions,
            "price": self.price,
            "currency": self.currency,
            "stock": self.stock,
            "discounted_price": self.discountedPrice,
            "images": self.images,
            "password": self.password
        ]
    }
}
