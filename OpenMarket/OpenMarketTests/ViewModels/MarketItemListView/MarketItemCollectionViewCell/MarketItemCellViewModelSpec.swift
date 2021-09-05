//
//  MarketItemCellViewModelSpec.swift
//  OpenMarketTests
//
//  Created by Ryan-Son on 2021/09/05.
//

import Nimble
import Quick
@testable import OpenMarket

final class MarketItemCellViewModelSpec: QuickSpec {

    override func spec() {
        describe("MarketItemCellViewModelSpec") {

            describe("bind") {
                context("fire를 실행하면") {
                    let stubThumbnailUseCase = StubThumbnailUseCase()
                    let dummyMarketItem = TestAssets.Dummies.marketItem
                    let sut = MarketItemCellViewModel(marketItem: dummyMarketItem, thumbnailUseCase: stubThumbnailUseCase)
                    it("update block이 실행되어 metaData를 통해 View를 업데이트할 기회를 제공한다") {
                        var isUpdateCalled: Bool = false
                        let expectedTitle = dummyMarketItem.title
                        let expectedThumbnailData = TestAssets.Expected.image.pngData()!
                        let expectedPrice = "\(dummyMarketItem.currency) \(dummyMarketItem.price.priceFormatted())"
                        let expectedStock = "재고: \(dummyMarketItem.stock)"

                        sut.bind { state in
                            if case .update(let metaData) = state {
                                isUpdateCalled = true
                                expect(isUpdateCalled).to(beTrue())
                                expect(metaData.title).to(equal(expectedTitle))
                                expect(metaData.thumbnail!.pngData()!).to(equal(expectedThumbnailData))
                                expect(metaData.hasDiscountedPrice).to(beFalse())
                                expect(metaData.discountedPrice.string.isEmpty).to(beTrue())
                                expect(metaData.price).to(equal(expectedPrice))
                                expect(metaData.isOutOfStock).to(beFalse())
                                expect(metaData.stock).to(equal(expectedStock))
                            }
                        }
                        sut.fire()
                    }
                }
                
                context("할인 가격을 가진 item을 가진 상태로 fire를 실행하면") {
                    let stubThumbnailUseCase = StubThumbnailUseCase()
                    let dummyMarketItem = TestAssets.Dummies.marketItemWithDiscountedPrice
                    let sut = MarketItemCellViewModel(marketItem: dummyMarketItem, thumbnailUseCase: stubThumbnailUseCase)
                    it("할인 가격은 기존 가격에 취소선이 적용되고 가격은 할인 가격으로 표시된다") {
                        let expectedDiscountedPrice: NSAttributedString = "\(dummyMarketItem.currency) \(dummyMarketItem.price.priceFormatted())".strikeThrough()
                        let expectedPrice = "\(dummyMarketItem.currency) \(dummyMarketItem.discountedPrice!.priceFormatted())"

                        sut.bind { state in
                            if case .update(let metaData) = state {
                                expect(metaData.hasDiscountedPrice).to(beTrue())
                                expect(metaData.discountedPrice).to(equal(expectedDiscountedPrice))
                                expect(metaData.price).to(equal(expectedPrice))
                            }
                        }
                        sut.fire()
                    }
                }

                context("재고가 없는 item을 가진 상태로 fire를 실행하면") {
                    let stubThumbnailUseCase = StubThumbnailUseCase()
                    let dummyMarketItem = TestAssets.Dummies.marketItemWithOutOfStock
                    let sut = MarketItemCellViewModel(marketItem: dummyMarketItem, thumbnailUseCase: stubThumbnailUseCase)
                    it("재고가 품절으로 표시된다") {
                        let expectedStock = "품절"

                        sut.bind { state in
                            if case .update(let metaData) = state {
                                expect(metaData.isOutOfStock).to(beTrue())
                                expect(metaData.stock).to(equal(expectedStock))
                            }
                        }
                        sut.fire()
                    }
                }

                context("재고가 999개를 초과하는 item을 가진 상태로 fire를 실행하면") {
                    let stubThumbnailUseCase = StubThumbnailUseCase()
                    let dummyMarketItem = TestAssets.Dummies.marketItemThatExceedLimitStock
                    let sut = MarketItemCellViewModel(marketItem: dummyMarketItem, thumbnailUseCase: stubThumbnailUseCase)
                    it("재고가 999+로 표시된다") {
                        let expectedStock = "재고: 999+"

                        sut.bind { state in
                            if case .update(let metaData) = state {
                                expect(metaData.isOutOfStock).to(beFalse())
                                expect(metaData.stock).to(equal(expectedStock))
                            }
                        }
                        sut.fire()
                    }
                }
            }

            describe("cancelThumbnailRequest") {
                let stubThumbnailUseCase = StubThumbnailUseCase()
                let dummyMarketItem = TestAssets.Dummies.marketItemThatExceedLimitStock
                let sut = MarketItemCellViewModel(marketItem: dummyMarketItem, thumbnailUseCase: stubThumbnailUseCase)
                it("실행 시 thumbnail task를 취소한다") {
                    let expectedTaskState: URLSessionTask.State = .canceling
                    sut.fire()
                    sut.cancelThumbnailRequest()
                    expect(sut.thumbnailTask?.state).to(equal(expectedTaskState))
                }
            }

            describe("prefetchThumbnail") {
                let stubThumbnailUseCase = StubThumbnailUseCase()
                let dummyMarketItem = TestAssets.Dummies.marketItemThatExceedLimitStock
                let sut = MarketItemCellViewModel(marketItem: dummyMarketItem, thumbnailUseCase: stubThumbnailUseCase)
                it("실행 시 뷰에 반영하지 않지만 미리 네트워크 작업을 요청하여 thumbnail을 캐시에 저장해둔다") {
                    sut.prefetchThumbnail()
                    let path = TestAssets.Expected.thumbnailURLString
                    let url = NSURL(string: path)!
                    let expected: UIImage? = ThumbnailUseCase.sharedCache.object(forKey: url)
                    expect(expected).toNot(beNil())
                }
            }
        }
    }
}
