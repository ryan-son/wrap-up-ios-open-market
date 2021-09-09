//
//  MarketItemRegisterViewModelSpec.swift
//  OpenMarketTests
//
//  Created by Ryan-Son on 2021/09/06.
//

import Nimble
import Quick
@testable import OpenMarket

final class MarketItemRegisterViewModelSpec: QuickSpec {

    override func spec() {
        describe("MarketItemRegisterViewModel") {
            var stubMarketItemRegisterUseCase: StubMarketItemRegisterUseCase!
            var sut: MarketItemRegisterViewModel!

            beforeEach {
                stubMarketItemRegisterUseCase = StubMarketItemRegisterUseCase()
                sut = MarketItemRegisterViewModel(marketItem: nil, useCase: stubMarketItemRegisterUseCase)

            }
            afterEach {
                sut = nil
                stubMarketItemRegisterUseCase = nil
            }

            describe("upload") {
                context("등록할 상품을 전달하면") {
                    it("등록된 상품이 MarketItem 형태로 반환된다") {
                        let expected: MarketItem = TestAssets.Expected.detailMarketItem
                        sut = MarketItemRegisterViewModel(marketItem: expected, useCase: stubMarketItemRegisterUseCase)
                        let postMarketItem: PostMarketItem = TestAssets.Dummies.postMarketItem
                        sut.bind { state in
                            if case .register(let posted) = state {
                                expect(posted).to(equal(expected))
                            }
                        }
                        sut.upload(postMarketItem, by: .post)
                        expect(stubMarketItemRegisterUseCase.uploadCallCount).to(equal(1))
                    }
                }

                context("수정할 상품을 전달하면") {
                    it("수정된 상품이 MarketItem 형태로 반환된다") {
                        let patchMarketItem: PatchMarketItem = TestAssets.Dummies.patchMarketItem
                        let expected: MarketItem = TestAssets.Expected.detailMarketItem
                        sut.bind { state in
                            if case .update(let updated) = state {
                                expect(updated).to(equal(expected))
                            }
                        }
                        sut.upload(patchMarketItem, by: .patch)
                        expect(stubMarketItemRegisterUseCase.uploadCallCount).to(equal(1))
                    }
                }
            }

            describe("appendImage") {
                context("image를 전달하면") {
                    it("images 배열에 요소가 추가되고 바인딩 상태가 appendImage로 설정된다") {
                        var appendImageCallCount: Int = .zero
                        sut.bind { state in
                            if case .appendImage(let index) = state {
                                appendImageCallCount += 1
                                expect(index).to(equal(.zero))
                            }
                        }
                        let image: UIImage = TestAssets.Expected.image
                        sut.appendImage(image)
                        expect(sut.images.first).to(equal(image))
                        expect(sut.images.count).to(equal(1))
                        expect(appendImageCallCount).toEventually(equal(1))
                    }
                }
            }

            describe("removeImage") {
                context("images 배열에 이미지가 있는 index를 전달하면") {
                    it("등록된 이미지가 배열에서 제거된다") {
                        sut.bind { state in
                            if case .deleteImage(let index) = state {
                                expect(index).to(equal(.zero))
                            }
                        }
                        let image: UIImage = TestAssets.Expected.image
                        sut.appendImage(image)
                        expect(sut.images.first).to(equal(image))
                        expect(sut.images.count).to(equal(1))

                        sut.removeImage(at: .zero)
                        expect(sut.images).to(beEmpty())
                    }
                }
            }

            describe("setMarketItemInfo") {
                context("TextViewType과 설정할 text를 전달하면") {
                    it("전달한 text가 ViewModel의 프로퍼티로 설정된다") {
                        let expectedTitle: String = "title"
                        sut.setMarketItemInfo(of: .title, with: expectedTitle)

                        let expectedDescriptions: String = "descriptions"
                        sut.setMarketItemInfo(of: .descriptions, with: expectedDescriptions)

                        let expectedPrice: String = "39900"
                        sut.setMarketItemInfo(of: .price, with: expectedPrice)

                        let expectedDiscountedPrice: String = "24900"
                        sut.setMarketItemInfo(of: .discountedPrice, with: expectedDiscountedPrice)

                        let expectedStock: String = "999+"
                        sut.setMarketItemInfo(of: .stock, with: expectedStock)

                        let expectedPassword: String = "RyanMarket"
                        sut.setMarketItemInfo(of: .password, with: expectedPassword)
                    }
                }
            }

            describe("setMarketItemCurrency") {
                context("설정할 화폐 단위를 전달하면") {
                    it("ViewModel 프로퍼티에 전달된 화폐 단위가 설정된다") {
                        let expectedCurrency: String = "KRW"
                        sut.setMarketItemCurrency(with: expectedCurrency)
                        expect(sut.currency).to(equal(expectedCurrency))
                    }
                }
            }

            describe("marketItemToSubmit") {
                context("ViewModel에 marketItem이 할당되지 않은 상태로 실행하면") {
                    it("PostMarketItem 인스턴스를 반환한다") {
                        let marketItem = TestAssets.Dummies.postMarketItem
                        let expectedTitle: String = marketItem.title
                        let expectedDescriptions: String = marketItem.descriptions
                        let expectedPrice: String = "\(marketItem.price)"
                        let expectedDiscountedPrice: String = "\(marketItem.discountedPrice!)"
                        let expectedStock: String = "\(marketItem.stock)"
                        let expectedPassword: String = marketItem.password
                        let expectedCurrency: String = marketItem.currency
                        let expectedImages: [UIImage] = marketItem.images.map { UIImage(data: $0)! }

                        sut.setMarketItemInfo(of: .title, with: expectedTitle)
                        expect(sut.title).to(equal(expectedTitle))
                        sut.setMarketItemInfo(of: .descriptions, with: expectedDescriptions)
                        expect(sut.descriptions).to(equal(expectedDescriptions))
                        sut.setMarketItemInfo(of: .price, with: expectedPrice)
                        expect(sut.price).to(equal(expectedPrice))
                        sut.setMarketItemInfo(of: .discountedPrice, with: expectedDiscountedPrice)
                        expect(sut.discountedPrice).to(equal(expectedDiscountedPrice))
                        sut.setMarketItemInfo(of: .stock, with: expectedStock)
                        expect(sut.stock).to(equal(expectedStock))
                        sut.setMarketItemInfo(of: .password, with: expectedPassword)
                        sut.setMarketItemCurrency(with: expectedCurrency)
                        expectedImages.forEach { sut.appendImage($0) }

                        let expected = TestAssets.Dummies.postMarketItem
                        let result = sut.marketItemToSubmit()
                        expect(result).to(beAKindOf(MultipartUploadable.self))
                        expect(result).to(beAKindOf(PostMarketItem.self))

                        let casted = result as! PostMarketItem
                        expect(casted).to(equal(expected))
                        casted.images.forEach {
                            expect($0.count).to(beLessThan(sut.targetImageSizeInKB * 1024))
                        }
                    }
                }
                
                context("ViewModel에 marketItem이 할당된 상태로 실행하면") {
                    it("PatchMarketItem 인스턴스를 반환한다") {
                        let marketItem = TestAssets.Expected.detailMarketItem
                        sut = MarketItemRegisterViewModel(marketItem: marketItem, useCase: stubMarketItemRegisterUseCase)

                        let expectedTitle: String = marketItem.title
                        let expectedDescriptions: String = marketItem.descriptions!
                        let expectedPrice: String = "\(marketItem.price)"
                        let expectedDiscountedPrice: String = "\(marketItem.discountedPrice!)"
                        let expectedStock: String = "\(marketItem.stock)"
                        let expectedPassword: String = TestAssets.sharedPassword
                        let expectedCurrency: String = marketItem.currency
                        let expectedImages: [UIImage] = [TestAssets.Dummies.hammerImage,
                                                         TestAssets.Dummies.hammerFillImage]

                        sut.setMarketItemInfo(of: .title, with: expectedTitle)
                        expect(sut.title).to(equal(expectedTitle))
                        sut.setMarketItemInfo(of: .descriptions, with: expectedDescriptions)
                        expect(sut.descriptions).to(equal(expectedDescriptions))
                        sut.setMarketItemInfo(of: .price, with: expectedPrice)
                        expect(sut.price).to(equal(expectedPrice))
                        sut.setMarketItemInfo(of: .discountedPrice, with: expectedDiscountedPrice)
                        expect(sut.discountedPrice).to(equal(expectedDiscountedPrice))
                        sut.setMarketItemInfo(of: .stock, with: expectedStock)
                        expect(sut.stock).to(equal(expectedStock))
                        sut.setMarketItemInfo(of: .password, with: expectedPassword)
                        sut.setMarketItemCurrency(with: expectedCurrency)
                        expectedImages.forEach { sut.appendImage($0) }

                        let result = sut.marketItemToSubmit()
                        expect(result).to(beAKindOf(MultipartUploadable.self))
                        expect(result).to(beAKindOf(PatchMarketItem.self))

                        let casted = result as! PatchMarketItem
                        casted.images!.forEach {
                            expect($0.count).to(beLessThan(sut.targetImageSizeInKB * 1024))
                        }
                    }
                }
            }

            describe("startEditing") {
                context("ViewModel에 marketItem을 전달하여 이니셜라이즈 후 메서드를 실행하면") {
                    it("바인딩 상태가 startEdit으로 설정되어 관련 프로퍼티들이 이를 통해 전달된다") {
                        sut.bind { state in
                            if case let .startEdit(title, currency, price, discountedPrice, stock, password, descriptions) = state {
                                expect(title).to(equal(sut.title))
                                expect(currency).to(equal(sut.currency))
                                expect(price).to(equal(sut.price))
                                expect(discountedPrice).to(equal(sut.discountedPrice))
                                expect(stock).to(equal(sut.stock))
                                expect(password).to(equal(password))
                                expect(descriptions).to(equal(sut.descriptions))
                            }
                        }
                        let marketItem = TestAssets.Expected.detailMarketItem
                        let password: String = TestAssets.sharedPassword
                        sut = MarketItemRegisterViewModel(marketItem: marketItem, useCase: stubMarketItemRegisterUseCase)
                        sut.startEditing(with: password)
                    }
                }
            }
        }
    }
}

extension PostMarketItem: Equatable {

    public static func == (lhs: PostMarketItem, rhs: PostMarketItem) -> Bool {
        return lhs.title == rhs.title &&
            lhs.descriptions == rhs.descriptions &&
            lhs.price == rhs.price &&
            lhs.currency == rhs.currency &&
            lhs.stock == rhs.stock &&
            lhs.discountedPrice == rhs.discountedPrice &&
            lhs.images.count == rhs.images.count &&
            lhs.password == rhs.password
    }
}

extension PatchMarketItem: Equatable {

    public static func == (lhs: PatchMarketItem, rhs: PatchMarketItem) -> Bool {
        return lhs.title == rhs.title &&
            lhs.descriptions == rhs.descriptions &&
            lhs.price == rhs.price &&
            lhs.currency == rhs.currency &&
            lhs.stock == rhs.stock &&
            lhs.discountedPrice == rhs.discountedPrice &&
            lhs.images?.count == rhs.images?.count &&
            lhs.password == rhs.password
    }
}
