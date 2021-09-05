//
//  StubMarketItemListUseCase.swift
//  OpenMarketTests
//
//  Created by Ryan-Son on 2021/09/05.
//

@testable import OpenMarket

final class StubMarketItemListUseCase: MarketItemListUseCaseProtocol {

    private(set) var isFetching: Bool = false
    private(set) var isLastPage: Bool = false
    private(set) var page: Int = 1
    private(set) var fetchItemsCallCount: Int = .zero
    private(set) var refreshCallCount: Int = .zero
    
    func fetchItems(completion: @escaping (Result<[MarketItem], MarketItemListUseCaseError>) -> Void) {
        fetchItemsCallCount += 1
        page += 1
        isFetching = true

        if page == 3 {
            isLastPage = true
        }

        completion(.success(TestAssets.Expected.fetchedMarketItems))
    }
    
    func refresh() {
        refreshCallCount += 1
        page = 1
        isFetching = false
        isLastPage = false
    }
}
