//
//  MarketItemDetailUseCaseSpec.swift
//  OpenMarketTests
//
//  Created by Ryan-Son on 2021/09/05.
//

import Nimble
import Quick
@testable import OpenMarket

final class MarketItemDetailUseCaseSpec: QuickSpec {

    override func spec() {
        describe("MarketItemDetailUseCase") {
            var stubNetworkManager: StubNetworkManager!
            var sut: MarketItemDetailUseCaseProtocol!

            beforeEach {
                stubNetworkManager = StubNetworkManager()
                sut = MarketItemDetailUseCase(networkManager: stubNetworkManager)
            }
            afterEach {
                sut = nil
                stubNetworkManager = nil
            }

            describe("fetchMarketItemDetail") {
                context("id를 전달하면") {
                    it("개별 상품에 대한 상세 정보를 반환한다") {
                        let id: Int = TestAssets.Expected.FetchDetail.id
                        let expected: MarketItem = TestAssets.Expected.detailMarketItem

                        sut.fetchMarketItemDetail(itemID: id) { result in
                            switch result {
                            case .success(let detailMarketItem):
                                expect(detailMarketItem).to(equal(expected))
                            case .failure(let error):
                                XCTFail("동작이 예상과 다릅니다. Error: \(error)")
                            }
                        }
                        expect(stubNetworkManager.fetchCallCount).to(equal(1))
                    }
                }
            }

            describe("fetchImage") {
                context("이미지가 있는 인터넷 URL을 전달하면") {
                    it("이미지를 반환한다") {
                        let path: String = TestAssets.Expected.detailMarketItem.images![.zero]
                        let expected: Data = TestAssets.Dummies.imageData
                        sut.fetchImage(from: path) { result in
                            switch result {
                            case .success(let image):
                                let imageData = image.pngData()!
                                expect(imageData).to(equal(expected))
                            case .failure(let error):
                                XCTFail("동작이 예상과 다릅니다. Error: \(error)")
                            }
                        }
                        expect(stubNetworkManager.fetchCallCount).to(equal(1))
                    }
                }

                context("image가 아닌 Data가 있는 인터넷 URL을 전달하면") {
                    it("notAnImageOrEmptyData 에러를 반환한다") {
                        let path = EndPoint.item(id: 1).path
                        let expected: MarketItemDetailUseCaseError = .notAnImageOrEmptyData
                        sut.fetchImage(from: path) { result in
                            switch result {
                            case .success:
                                XCTFail("동작이 예상과 다릅니다.")
                            case .failure(let error):
                                expect(error).to(equal(expected))
                            }
                        }
                        expect(stubNetworkManager.fetchCallCount).to(equal(1))
                    }
                }
            }

            describe("deleteMarketItem") {
                context("삭제할 itemID와 password를 전달하면") {
                    it("삭제된 marketItem을 반환한다") {
                        let expected: MarketItem = TestAssets.Expected.detailMarketItem
                        let id: Int = expected.id
                        let password: String = TestAssets.sharedPassword

                        sut.deleteMarketItem(itemID: id, password: password) { result in
                            switch result {
                            case .success(let deletedMarketItem):
                                expect(deletedMarketItem).to(equal(expected))
                            case .failure(let error):
                                XCTFail("동작이 예상과 다릅니다. \(error)")
                            }
                        }
                        expect(stubNetworkManager.deleteCallCount).to(equal(1))
                    }
                }
            }

            describe("verifyPassword") {
                context("수정할 상품의 itemID와 password를 전달하면") {
                    it("해당 상품의 password를 확인하여 맞으면 해당 상품 정보를 반환한다") {
                        let expected: MarketItem = TestAssets.Expected.detailMarketItem
                        let id = expected.id
                        let password = TestAssets.sharedPassword
                        
                        sut.verifyPassword(itemID: id, password: password) { result in
                            switch result {
                            case .success(let marketItem):
                                expect(marketItem).to(equal(expected))
                            case .failure(let error):
                                XCTFail("동작이 예상과 다릅니다. Error: \(error)")
                            }
                        }
                        expect(stubNetworkManager.multipartUploadCallCount).to(equal(1))
                    }
                }
            }
        }
    }
}

extension MarketItemDetailUseCaseError: Equatable {

    public static func == (lhs: MarketItemDetailUseCaseError, rhs: MarketItemDetailUseCaseError) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }
}
