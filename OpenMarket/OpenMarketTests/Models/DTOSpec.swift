//
//  DTOSpec.swift
//  OpenMarketTests
//
//  Created by Ryan-Son on 2021/09/03.
//

import Nimble
import Quick
@testable import OpenMarket

final class DTOSpec: QuickSpec {

    override func spec() {
        describe("Data Transfer Objects (DTOs)") {

            describe("PostMarketItem") {
                let postMarketItem = TestAssets.Dummies.postMarketItem

                it("MultipartUploadable을 준수한다") {
                    expect(postMarketItem).to(beAKindOf(MultipartUploadable.self))
                }

                context("MultipartUploadable을 준수한다면") {
                    it("[String: Any?] 키-값 형태의 dictionary로 자신을 반환할 수 있다.") {
                        expect(postMarketItem.asDictionary).to(beAKindOf([String: Any?].self))
                    }

                    it("Dictionary 형태로 반환된 값은 기존의 값과 같다") {
                        expect(postMarketItem.asDictionary["title"] as? String).to(equal(TestAssets.Dummies.postMarketItem.title))
                        expect(postMarketItem.asDictionary["descriptions"] as? String).to(equal(TestAssets.Dummies.postMarketItem.descriptions))
                        expect(postMarketItem.asDictionary["price"] as? Int).to(equal(TestAssets.Dummies.postMarketItem.price))
                        expect(postMarketItem.asDictionary["currency"] as? String).to(equal(TestAssets.Dummies.postMarketItem.currency))
                        expect(postMarketItem.asDictionary["stock"] as? Int).to(equal(TestAssets.Dummies.postMarketItem.stock))
                        expect(postMarketItem.asDictionary["discounted_price"] as? Int).to(equal(TestAssets.Dummies.postMarketItem.discountedPrice))
                        expect(postMarketItem.asDictionary["images"] as? [Data]).to(equal(TestAssets.Dummies.postMarketItem.images))
                        expect(postMarketItem.asDictionary["password"] as? String).to(equal(TestAssets.sharedPassword))
                    }
                }
            }

            describe("PatchMarketItem") {
                let patchMarketItem = TestAssets.Dummies.patchMarketItem
                
                it("MultipartUploadable을 준수한다") {
                    expect(patchMarketItem).to(beAKindOf(MultipartUploadable.self))
                }

                context("MultipartUploadable을 준수한다면") {
                    it("[String: Any?] 키-값 형태의 dictionary로 자신을 반환할 수 있다.") {
                        expect(patchMarketItem.asDictionary).to(beAKindOf([String: Any?].self))
                    }

                    it("Dictionary 형태로 반환된 값은 기존의 값과 같다") {
                        expect(patchMarketItem.asDictionary["title"] as? String).to(equal(TestAssets.Dummies.patchMarketItem.title))
                        expect(patchMarketItem.asDictionary["images"] as? [Data]).to(equal(TestAssets.Dummies.patchMarketItem.images))
                        expect(patchMarketItem.asDictionary["password"] as? String).to(equal(TestAssets.sharedPassword))
                    }
                }
            }

            describe("DeleteMarketItem") {
                let deleteMarketItem = TestAssets.Dummies.deleteMarketItem
                
                it("Uploadable을 준수한다") {
                    expect(deleteMarketItem).to(beAKindOf(Uploadable.self))
                }
            }
        }
    }
}
