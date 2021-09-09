//
//  PatchMarketItem.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/08/30.
//

import Foundation

struct PatchMarketItem: MultipartUploadable {

    let title: String?
    let descriptions: String?
    let price: Int?
    let currency: String?
    let stock: Int?
    let discountedPrice: Int?
    let images: [Data]?
    let password: String

    var asDictionary: [String: Any?] {
        [
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
