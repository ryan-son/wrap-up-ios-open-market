//
//  MarketItemRegisterUseCaseSpec.swift
//  OpenMarketTests
//
//  Created by Ryan-Son on 2021/09/06.
//

import Nimble
import Quick
@testable import OpenMarket

final class MarketItemRegisterUseCaseSpec: QuickSpec {

    override func spec() {
        describe("MarketItemRegisterUseCase") {
            var stubNetworkManager: StubNetworkManager!
            var sut: MarketItemRegisterUseCaseProtocol!

            beforeEach {
                stubNetworkManager = StubNetworkManager()
                sut = MarketItemRegisterUseCase(networkManager: stubNetworkManager)
            }
            afterEach {
                sut = nil
                stubNetworkManager = nil
            }

            describe("upload") {
                context("등록할 상품을 DTO 모델인 PostMarketItem 인스턴스로 전달하면") {
                    it("등록된 상품이 MarketItem 형태로 반환한다") {
                        let postMarketItem = TestAssets.Dummies.postMarketItem
                        let expected: MarketItem = TestAssets.Expected.detailMarketItem
                        let path: String = EndPoint.uploadItem.path

                        sut.upload(postMarketItem, to: path, method: .post) { result in
                            switch result {
                            case .success(let posted):
                                expect(posted).to(equal(expected))
                            case .failure(let error):
                                XCTFail("동작이 예상과 다릅니다. Error: \(error)")
                            }
                        }
                    }
                }

                context("수정할 상품을 PatchMarketItem 인스턴스와 함께 Patch 메서드로 전달하면") {
                    it("수정된 상품이 MarketItem 형태로 반환된다") {
                        let patchMarketItem = TestAssets.Dummies.patchMarketItem
                        let expected: MarketItem = TestAssets.Expected.detailMarketItem
                        let path: String = EndPoint.item(id: expected.id).path

                        sut.upload(patchMarketItem, to: path, method: .patch) { result in
                            switch result {
                            case .success(let patched):
                                expect(patched).to(equal(expected))
                            case .failure(let error):
                                XCTFail("동작이 예상과 다릅니다. Error: \(error)")
                            }
                        }
                    }
                }
            }
        }
    }
}
