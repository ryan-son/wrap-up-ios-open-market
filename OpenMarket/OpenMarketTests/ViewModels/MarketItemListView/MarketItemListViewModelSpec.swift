//
//  MarketItemListViewModelSpec.swift
//  OpenMarketTests
//
//  Created by Ryan-Son on 2021/09/05.
//

import Nimble
import Quick
@testable import OpenMarket

final class MarketItemListViewModelSpec: QuickSpec {

    override func spec() {
        describe("MarketItemListViewModelSpec") {
            var stubMarketItemListUseCase: StubMarketItemListUseCase!
            var sut: MarketItemListViewModel!
            
            beforeEach {
                stubMarketItemListUseCase = StubMarketItemListUseCase()
                sut = MarketItemListViewModel(useCase: stubMarketItemListUseCase)
            }
            afterEach {
                sut = nil
                stubMarketItemListUseCase = nil
            }

            describe("bind") {
                context("list 실행을 통해 marketItems에 요소를 append하면") {
                    it("fetched block이 실행되어 marketItems 배열에 추가된 index를 indexPath 형태로 전달한다") {
                        var fetchedCallCount: Int = .zero
                        var indexPathsThatNeedUpdates: [IndexPath] = []
                        let expectedFetchedCallCount: Int = 1
                        let expectedIndexPathsThatNeedUpdates: [IndexPath] = [
                            IndexPath(item: .zero, section: .zero),
                            IndexPath(item: 1, section: .zero)
                        ]

                        sut.bind { state in
                            if case .fetched(let indexPaths)  = state {
                                fetchedCallCount += 1
                                indexPathsThatNeedUpdates = indexPaths
                                expect(fetchedCallCount).to(equal(expectedFetchedCallCount))
                                expect(indexPathsThatNeedUpdates).to(equal(expectedIndexPathsThatNeedUpdates))
                            }
                        }

                        sut.list()
                    }
                }

                context("refresh 실행을 통해 marketItems 배열의 요소를 모두 비우면") {
                    it("refreshed block이 실행되어 refresh 시 View에서 일어나야할 변화를 적용할 수 있는 기회를 제공한다") {
                        var refreshedCallCount: Int = .zero
                        let expectedRefreshedCallCount: Int = 1
                        sut.bind { state in
                            if case .refreshed = state {
                                refreshedCallCount += 1
                                expect(expectedRefreshedCallCount).to(equal(expectedRefreshedCallCount))
                            }
                        }

                        sut.refresh()
                    }
                }
            }
            
            describe("list") {
                it("실행 시 새로운 MarketItem 배열을 marketItems 배열에 append한다") {
                    let expected: [MarketItem] = TestAssets.Expected.fetchedMarketItems
                    sut.list()
                    expect(sut.marketItems).to(equal(expected))
                }
            }

            describe("refresh") {
                it("실행 시 useCase의 프로퍼티, marketItems를 모두 제거하고 다시 marketItem들을 로드한다") {
                    let expectedPage: Int = 1
                    let expectedMarketItems: [MarketItem] = TestAssets.Expected.fetchedMarketItems
                    sut.list()

                    sut.refresh()
                    expect(stubMarketItemListUseCase.isFetching).to(beFalse())
                    expect(stubMarketItemListUseCase.isLastPage).to(beFalse())
                    expect(stubMarketItemListUseCase.page).to(equal(expectedPage))
                    expect(sut.marketItems).to(equal(expectedMarketItems))
                    expect(sut.marketItems.count).to(equal(expectedMarketItems.count))
                }
            }
        }
    }
}
