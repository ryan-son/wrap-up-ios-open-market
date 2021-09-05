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

        static let imageData: Data = TestAssets.Expected.image.pngData()!
        static let bookImageData = UIImage(systemName: "book")!.jpegData(compressionQuality: 1.0)!
        static let hammerImageData = UIImage(systemName: "hammer")!.jpegData(compressionQuality: 1.0)!
        static let hammerFillImageData = UIImage(systemName: "hammer.fill")!.jpegData(compressionQuality: 1.0)!
        static let postMarketItem = PostMarketItem(title: TestAssets.Expected.Post.title,
                                                   descriptions: TestAssets.Expected.Post.descriptions,
                                                   price: TestAssets.Expected.Post.price,
                                                   currency: TestAssets.Expected.Post.currency,
                                                   stock: TestAssets.Expected.Post.stock,
                                                   discountedPrice: TestAssets.Expected.Post.discountedPrice,
                                                   images: [
                                                    TestAssets.Dummies.hammerImageData,
                                                    TestAssets.Dummies.hammerFillImageData
                                                   ],
                                                   password: TestAssets.sharedPassword)
        static let patchMarketItem = PatchMarketItem(title: TestAssets.Expected.Patch.title,
                                                     descriptions: nil,
                                                     price: nil,
                                                     currency: nil,
                                                     stock: nil,
                                                     discountedPrice: nil,
                                                     images: [bookImageData],
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
                                                                        images: [hammerImageData],
                                                                        password: TestAssets.sharedPassword)
        static let deleteMarketItem = DeleteMarketItem(password: TestAssets.sharedPassword)
        static let marketItem = MarketItem(id: 43,
                                           title: "Apple Pencil",
                                           descriptions: nil,
                                           price: 165,
                                           currency: "USD",
                                           stock: 10,
                                           discountedPrice: nil,
                                           thumbnails: [
                                            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/3371E602-2C29-4734-8A9A-83A37DD24EAE.png",
                                            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/847BD5A2-8BFF-4A7F-BAD4-75E59330445D.png"
                                           ],
                                           images: nil,
                                           registrationDate: 1620633040.6505718)
        static let marketItemWithDiscountedPrice = MarketItem(id: 43,
                                                              title: "Apple Pencil",
                                                              descriptions: nil,
                                                              price: 165,
                                                              currency: "USD",
                                                              stock: 10,
                                                              discountedPrice: 160,
                                                              thumbnails: [
                                                                "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/3371E602-2C29-4734-8A9A-83A37DD24EAE.png",
                                                                "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/847BD5A2-8BFF-4A7F-BAD4-75E59330445D.png"
                                                              ],
                                                              images: nil,
                                                              registrationDate: 1620633040.6505718)
        static let marketItemWithOutOfStock = MarketItem(id: 43,
                                                     title: "Apple Pencil",
                                                     descriptions: nil,
                                                     price: 165,
                                                     currency: "USD",
                                                     stock: .zero,
                                                     discountedPrice: nil,
                                                     thumbnails: [
                                                        "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/3371E602-2C29-4734-8A9A-83A37DD24EAE.png",
                                                        "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/847BD5A2-8BFF-4A7F-BAD4-75E59330445D.png"
                                                     ],
                                                     images: nil,
                                                     registrationDate: 1620633040.6505718)
        static let marketItemThatExceedLimitStock = MarketItem(id: 43,
                                                     title: "Apple Pencil",
                                                     descriptions: nil,
                                                     price: 165,
                                                     currency: "USD",
                                                     stock: 1000,
                                                     discountedPrice: nil,
                                                     thumbnails: [
                                                        "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/3371E602-2C29-4734-8A9A-83A37DD24EAE.png",
                                                        "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/847BD5A2-8BFF-4A7F-BAD4-75E59330445D.png"
                                                     ],
                                                     images: nil,
                                                     registrationDate: 1620633040.6505718)
    }

    enum Expected {

        static let thumbnailURLString: String = "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/3371E602-2C29-4734-8A9A-83A37DD24EAE.png"
        static let image = UIImage(named: "test")!
        static let fetchMarketItemListData: Data = """
            {
                "page": \(TestAssets.Expected.FetchList.pageNumber),
                "items": [
                    {
                      "registration_date": \(TestAssets.Expected.FetchList.fetchMarketItemForList1.registrationDate),
                      "price": \(TestAssets.Expected.FetchList.fetchMarketItemForList1.price),
                      "id": \(TestAssets.Expected.FetchList.fetchMarketItemForList1.id),
                      "currency": "\(TestAssets.Expected.FetchList.fetchMarketItemForList1.currency)",
                      "title": "\(TestAssets.Expected.FetchList.fetchMarketItemForList1.title)",
                      "thumbnails": \(TestAssets.Expected.FetchList.fetchMarketItemForList1.thumbnails),
                      "stock": \(TestAssets.Expected.FetchList.fetchMarketItemForList1.stock),
                      "discounted_price": \(TestAssets.Expected.FetchList.fetchMarketItemForList1.discountedPrice!)
                    },
                    {
                      "registration_date": \(TestAssets.Expected.FetchList.fetchMarketItemForList2.registrationDate),
                      "price": \(TestAssets.Expected.FetchList.fetchMarketItemForList2.price),
                      "id": \(TestAssets.Expected.FetchList.fetchMarketItemForList2.id),
                      "currency": "\(TestAssets.Expected.FetchList.fetchMarketItemForList2.currency)",
                      "title": "\(TestAssets.Expected.FetchList.fetchMarketItemForList2.title)",
                      "thumbnails": \(TestAssets.Expected.FetchList.fetchMarketItemForList2.thumbnails),
                      "stock": \(TestAssets.Expected.FetchList.fetchMarketItemForList2.stock)
                    }
                ]
            }
            """.data(using: .utf8)!
        static let fetchMarketItemDetailData = """
            {
              "id": \(TestAssets.Expected.FetchDetail.id),
              "discounted_price": \(TestAssets.Expected.FetchDetail.discountedPrice),
              "descriptions": "\(TestAssets.Expected.FetchDetail.descriptions)",
              "currency": "\(TestAssets.Expected.FetchDetail.currency)",
              "images": \(TestAssets.Expected.FetchDetail.images),
              "thumbnails": \(TestAssets.Expected.FetchDetail.thumbnails),
              "stock": \(TestAssets.Expected.FetchDetail.stock),
              "title": "\(TestAssets.Expected.FetchDetail.title)",
              "registration_date": \(TestAssets.Expected.FetchDetail.registrationDate),
              "price": \(TestAssets.Expected.FetchDetail.price)
            }
            """.data(using: .utf8)!
        static let detailMarketItem = MarketItem(id: TestAssets.Expected.FetchDetail.id,
                                                 title: TestAssets.Expected.FetchDetail.title,
                                                 descriptions: TestAssets.Expected.FetchDetail.descriptions,
                                                 price: TestAssets.Expected.FetchDetail.price,
                                                 currency: TestAssets.Expected.FetchDetail.currency,
                                                 stock: TestAssets.Expected.FetchDetail.stock,
                                                 discountedPrice: TestAssets.Expected.FetchDetail.discountedPrice,
                                                 thumbnails: TestAssets.Expected.FetchDetail.thumbnails,
                                                 images: TestAssets.Expected.FetchDetail.images,
                                                 registrationDate: TestAssets.Expected.FetchDetail.registrationDate)
        static let postMarketItemData = """
            {
              "registration_date": \(TestAssets.Expected.Post.registrationDate),
              "currency": \(TestAssets.Expected.Post.currency),
              "price": \(TestAssets.Expected.Post.price),
              "discounted_price": \(TestAssets.Expected.Post.discountedPrice),
              "id": \(TestAssets.Expected.Post.id),
              "stock": \(TestAssets.Expected.Post.stock),
              "title": \(TestAssets.Expected.Post.title),
              "images": \(TestAssets.Expected.Post.images),
              "descriptions": \(TestAssets.Expected.Post.descriptions)
            }
            """.data(using: .utf8)!
        static let patchMarketItemData = """
            {
              "registration_date": \(TestAssets.Expected.Post.registrationDate),
              "currency": \(TestAssets.Expected.Post.currency),
              "price": \(TestAssets.Expected.Post.price),
              "discounted_price": \(TestAssets.Expected.Post.discountedPrice),
              "id": \(TestAssets.Expected.Post.id),
              "stock": \(TestAssets.Expected.Post.stock),
              "title": \(TestAssets.Expected.Patch.title),
              "images": \(TestAssets.Expected.Patch.images),
              "descriptions": \(TestAssets.Expected.Post.descriptions)
            }
            """.data(using: .utf8)!
        static let fetchedMarketItems: [MarketItem] = [
            TestAssets.Expected.FetchList.fetchMarketItemForList1,
            TestAssets.Expected.FetchList.fetchMarketItemForList2
        ]
        static let deleteMarketItemData = """
            {
                "password": \(TestAssets.sharedPassword)
            }
            """.data(using: .utf8)!

        enum FetchDetail {
            static let stock: Int = 90
            static let images: [String] = [
                "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/A842F79B-299E-4E28-838D-2C17C89FF942.png"
            ]
            static let thumbnails: [String] = [
                "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/A842F79B-299E-4E28-838D-2C17C89FF942.png"
            ]
            static let title: String = "Mac mini"
            static let currency: String = "KRW"
            static let id: Int = 41
            static let discountedPrice: Int = 89000
            static let price: Int = 890000
            static let registrationDate: TimeInterval = 1620633229.6858091
            static let descriptions: String = "Apple M1 칩이 우리의 가장 다재다능한 데스크탑의 능력을 완전히 새로운 차원으로 끌어올려줍니다."
            static let error: NetworkManagerError = .gotFailedResponse(statusCode: 400)
        }
        
        enum Post {
            static let registrationDate: TimeInterval = 1620711646.640805
            static let currency: String = "KRW"
            static let price: Int = 37000
            static let discountedPrice: Int = 1221
            static let id: Int = 74
            static let stock: Int = 129
            static let title: String = "에어태그"
            static let images: [String] = [
              "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/A84BC431-A4F6-4ED8-997F-A128929FB512.png",
              "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/B5EAF567-5296-4F91-9294-718E24CB96B2.png"
            ]
            static let descriptions: String = "극강의 가성비"
            static let error: NetworkManagerError = .gotFailedResponse(statusCode: 400)
        }

        enum Patch {
            static let id: Int = TestAssets.Expected.Post.id
            static let title: String = "어이쿠 제목을 잘못 올렸네요"
            static let images: [String] = [
                "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/B5EAF567-5296-4F91-9294-718E24CB96B2.png"
            ]
            static let error: NetworkManagerError = .gotFailedResponse(statusCode: 400)
        }

        enum Delete {
            static let successStatusCode: Int = 200
            static let error: NetworkManagerError = .gotFailedResponse(statusCode: 400)
        }

        enum FetchList {
            static let pageNumber: Int = 1
            static let fetchMarketItemForList1 = MarketItem(id: 43,
                                                            title: "Apple Pencil",
                                                            descriptions: nil,
                                                            price: 165,
                                                            currency: "USD",
                                                            stock: 5000000,
                                                            discountedPrice: 160,
                                                            thumbnails: [
                                                                "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/3371E602-2C29-4734-8A9A-83A37DD24EAE.png",
                                                                "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/847BD5A2-8BFF-4A7F-BAD4-75E59330445D.png"
                                                            ],
                                                            images: nil,
                                                            registrationDate: 1620633040.6505718)
            static let fetchMarketItemForList2 = MarketItem(id: 40,
                                                            title: "MacBook Pro",
                                                            descriptions: nil,
                                                            price: 1690,
                                                            currency: "USD",
                                                            stock: 0,
                                                            discountedPrice: nil,
                                                            thumbnails: [
                                                                "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/DE1506F3-2289-4AB2-892C-4AD0C72C02EF.png",
                                                                "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1F8FD761-CE80-4B5A-B438-777230508FD9.png"
                                                            ],
                                                            images: nil,
                                                            registrationDate: 1620633347.3906322)
            static let error: NetworkManagerError = .gotFailedResponse(statusCode: 400)
        }
    }
}
