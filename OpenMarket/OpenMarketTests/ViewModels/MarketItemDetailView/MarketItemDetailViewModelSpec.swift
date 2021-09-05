//
//  MarketItemDetailViewModelSpec.swift
//  OpenMarketTests
//
//  Created by Ryan-Son on 2021/09/06.
//

import Nimble
import Quick
@testable import OpenMarket

final class MarketItemDetailViewModelSpec: QuickSpec {

    override func spec() {
        describe("MarketItemDetailViewModel") {
            var stubMarketItemDetailUseCase: StubMarketItemDetailUseCase!
            var sut: MarketItemDetailViewModel!

            beforeEach {
                stubMarketItemDetailUseCase = StubMarketItemDetailUseCase()
                sut = MarketItemDetailViewModel(marketItemID: TestAssets.Expected.FetchDetail.id,
                                                useCase: stubMarketItemDetailUseCase)
            }
            afterEach {
                sut = nil
                stubMarketItemDetailUseCase = nil
            }

            describe("bind") {
                context("fire을 실행하면") {
                    it("marketItem과 images가 할당되고 바인딩 state을 통해 metaData와 image들이 전달된다") {
                        let expected: MarketItem = TestAssets.Expected.detailMarketItem
                        sut.bind { state in
                            var fetchCallCount: Int = .zero
                            var fetchImageCallCount: Int = .zero
                            let expectedDiscountedPrice: NSAttributedString = "\(expected.currency) \(expected.price.priceFormatted())".strikeThrough()
                            let expectedPrice: String = "\(expected.currency) \(expected.discountedPrice!.priceFormatted())"
                            let expectedStock: String = "재고: \(expected.stock)"
                            let expectedImageData: Data = TestAssets.Expected.image.pngData()!
                            switch state {
                            case .fetch(let metaData):
                                fetchCallCount += 1
                                expect(metaData.title).to(equal(expected.title))
                                expect(metaData.descriptions).to(equal(expected.descriptions))
                                expect(metaData.hasDiscountedPrice).to(beTrue())
                                expect(metaData.discountedPrice).to(equal(expectedDiscountedPrice))
                                expect(metaData.price).to(equal(expectedPrice))
                                expect(metaData.isOutOfStock).to(beFalse())
                                expect(metaData.stock).to(equal(expectedStock))
                                expect(metaData.numberOfImages).to(equal(expected.images?.count))
                            case .fetchImage(let image, _):
                                fetchImageCallCount += 1
                                let imageData: Data = image.pngData()!
                                expect(imageData).to(equal(expectedImageData))
                            default:
                                break
                            }
                        }
                        sut.fire()
                        expect(sut.marketItem).toNotEventually(beNil())
                        expect(sut.images.count).toEventually(equal(expected.images?.count))
                    }
                }
            }

            describe("verifyPassword") {
                context("올바른 password를 전달하면") {
                    it("수정할 상품의 현재 상태를 marketItem에 등록하고 verify state로 이를 전달한다") {
                        let expectedPassword: String = TestAssets.sharedPassword
                        let expected: MarketItem = TestAssets.Expected.detailMarketItem

                        sut.bind { state in
                            switch state {
                            case .verify(let marketItem, let password):
                                expect(marketItem).to(equal(expected))
                                expect(password).to(equal(expectedPassword))
                            default:
                                break
                            }
                        }
                        sut.verifyPassword(expectedPassword)
                        expect(sut.marketItem).to(equal(expected))
                    }
                }

                context("올바르지 않은 password를 전달하면") {
                    it("404 에러를 전달 받아 바인딩 상태가 failedToStartEdit으로 세팅된다") {
                        stubMarketItemDetailUseCase.shouldFailWithFailedResponse = true
                        var failedToStartEditCallCount: Int = .zero
                        sut.bind { state in
                            switch state {
                            case .failedToStartEdit:
                                failedToStartEditCallCount += 1

                            default:
                                break
                            }
                        }
                        sut.verifyPassword("invalid")
                        expect(failedToStartEditCallCount).toEventually(equal(1))
                    }
                }
            }

            describe("deleteMarketItem") {
                context("올바른 password를 전달하면") {
                    it("바인딩 상태가 delete로 세팅된다") {
                        let password: String = TestAssets.sharedPassword
                        var deleteCallCount: Int = .zero
                        sut.bind { state in
                            switch state {
                            case .delete:
                                deleteCallCount += 1
                            default:
                                break
                            }
                        }
                        sut.deleteMarketItem(with: password)
                        expect(deleteCallCount).toEventually(equal(1))
                    }
                }

                context("올바르지 않은 password를 전달하면") {
                    it("404 에러를 전달 받아 바인딩 상태가 deleteFailed로 세팅된다") {
                        stubMarketItemDetailUseCase.shouldFailWithFailedResponse = true
                        var deleteFailedCallCount: Int = .zero
                        sut.bind { state in
                            switch state {
                            case .deleteFailed:
                                deleteFailedCallCount += 1
                            default:
                                break
                            }
                        }
                        sut.deleteMarketItem(with: "invalid")
                        expect(deleteFailedCallCount).toEventually(equal(1))
                    }
                }
            }
        }
    }
}
