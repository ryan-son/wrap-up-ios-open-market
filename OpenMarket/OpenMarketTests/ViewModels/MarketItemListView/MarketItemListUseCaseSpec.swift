//
//  MarketItemListUseCaseSpec.swift
//  OpenMarketTests
//
//  Created by Ryan-Son on 2021/09/05.
//

import Nimble
import Quick
@testable import OpenMarket

final class MarketItemListUseCaseSpec: QuickSpec {

    override func spec() {
        describe("MarketItemListUseCase") {
            var stubNetworkManager: StubNetworkManager!
            var sut: MarketItemListUseCaseProtocol!

            beforeEach {
                stubNetworkManager = StubNetworkManager()
                sut = MarketItemListUseCase(networkManager: stubNetworkManager)
            }
            afterEach {
                sut = nil
                stubNetworkManager = nil
            }

            describe("fetchItems") {
                it("실행 시 MarketItem 배열을 반환한다") {
                    let expected: [MarketItem] = TestAssets.Expected.fetchedMarketItems
                    sut.fetchItems { result in
                        switch result {
                        case .success(let marketItems):
                            expect(marketItems).to(equal(expected))
                        case .failure(let error):
                            XCTFail("동작이 예상과 다릅니다. Error: \(error)")
                        }
                    }
                    expect(stubNetworkManager.fetchCallCount).to(equal(1))
                }
            }

            describe("refresh") {
                it("실행 시 순차적인 페이지 로드를 위해 사용되었던 프로퍼티들이 초기화된다") {
                    sut.fetchItems { _ in }
                    sut.refresh()
                    expect(stubNetworkManager.fetchCallCount).to(equal(1))
                    expect(sut.isFetching).to(beFalse())
                    expect(sut.isLastPage).to(beFalse())
                    expect(sut.page).to(equal(1))
                }
            }
        }
    }
}

extension MarketItem: Equatable {

    public static func == (lhs: MarketItem, rhs: MarketItem) -> Bool {
        return lhs.id == rhs.id &&
            lhs.currency == rhs.currency &&
            lhs.descriptions == rhs.descriptions &&
            lhs.discountedPrice == rhs.discountedPrice &&
            lhs.images == rhs.images &&
            lhs.price == rhs.price &&
            lhs.registrationDate == rhs.registrationDate
    }
}
