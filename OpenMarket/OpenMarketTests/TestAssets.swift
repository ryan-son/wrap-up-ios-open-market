//
//  TestAssets.swift
//  OpenMarketTests
//
//  Created by Ryan-Son on 2021/09/03.
//

import UIKit.UIImage
@testable import OpenMarket

enum TestAssets {

    static let sharedPassword: String = "RyanMarket"

    enum Dummies {
        static let bookImageData = UIImage(systemName: "book")!.jpegData(compressionQuality: 1.0)!
        static let hammerImageData = UIImage(systemName: "hammer")!.jpegData(compressionQuality: 1.0)!
        static let hammerFillImageData = UIImage(systemName: "hammer.fill")!.jpegData(compressionQuality: 1.0)!
        static let postMarketItem = PostMarketItem(title: TestAssets.Expected.PostMarketItem.title,
                                                   descriptions: TestAssets.Expected.PostMarketItem.descriptions,
                                                   price: TestAssets.Expected.PostMarketItem.price,
                                                   currency: TestAssets.Expected.PostMarketItem.currency,
                                                   stock: TestAssets.Expected.PostMarketItem.stock,
                                                   discountedPrice: TestAssets.Expected.PostMarketItem.discountedPrice,
                                                   images: TestAssets.Expected.PostMarketItem.images,
                                                   password: TestAssets.sharedPassword)
        static let patchMarketItem = PatchMarketItem(title: TestAssets.Expected.PatchMarketItem.title,
                                                     descriptions: TestAssets.Expected.PatchMarketItem.descriptions,
                                                     price: TestAssets.Expected.PatchMarketItem.price,
                                                     currency: TestAssets.Expected.PatchMarketItem.currency,
                                                     stock: TestAssets.Expected.PatchMarketItem.stock,
                                                     discountedPrice: TestAssets.Expected.PatchMarketItem.discountedPrice,
                                                     images: TestAssets.Expected.PatchMarketItem.images,
                                                     password: TestAssets.sharedPassword)
        static let patchMarketItemThatOnlyHasPassword = PatchMarketItem(title: nil,
                                                                        descriptions: nil,
                                                                        price: nil,
                                                                        currency: nil,
                                                                        stock: nil,
                                                                        discountedPrice: nil,
                                                                        images: nil,
                                                                        password: TestAssets.sharedPassword)
        static let patchMarketItemThatOnlyHasOneImage = PatchMarketItem(title: nil,
                                                                        descriptions: nil,
                                                                        price: nil,
                                                                        currency: nil,
                                                                        stock: nil,
                                                                        discountedPrice: nil,
                                                                        images: TestAssets.Expected.PatchMarketItem.images,
                                                                        password: TestAssets.sharedPassword)
        static let deleteMarketItem = DeleteMarketItem(password: TestAssets.sharedPassword)
    }

    enum Expected {

        enum PostMarketItem {
            static let title: String = "상품 제목"
            static let descriptions: String = "상품 상세"
            static let price: Int = 39900
            static let currency: String = "KRW"
            static let stock: Int = 1000
            static let discountedPrice: Int = 34900
            static let images: [Data] = [TestAssets.Dummies.hammerImageData, TestAssets.Dummies.hammerFillImageData]
        }

        enum PatchMarketItem {
            static let title: String = "수정된 상품 제목"
            static let descriptions: String = "수정된 상품 상세"
            static let price: Int = 35
            static let currency: String = "USD"
            static let stock: Int = 10
            static let discountedPrice: Int = 30
            static let images: [Data] = [TestAssets.Dummies.bookImageData]
        }

        
    }
}
