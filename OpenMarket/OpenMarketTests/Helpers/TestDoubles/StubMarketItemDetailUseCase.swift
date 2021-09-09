//
//  StubMarketItemDetailUseCase.swift
//  OpenMarketTests
//
//  Created by Ryan-Son on 2021/09/06.
//

import UIKit.UIImage
@testable import OpenMarket

final class StubMarketItemDetailUseCase: MarketItemDetailUseCaseProtocol {

    var shouldFailWithFailedResponse: Bool = false

    func fetchMarketItemDetail(
        itemID: Int,
        completion: @escaping ((Result<MarketItem, MarketItemDetailUseCaseError>) -> Void)
    ) {
        completion(.success(TestAssets.Expected.detailMarketItem))
    }
    
    func fetchImage(
        from path: String,
        completion: @escaping (Result<UIImage, MarketItemDetailUseCaseError>) -> Void
    ) {
        completion(.success(TestAssets.Expected.image))
    }
    
    func deleteMarketItem(
        itemID: Int,
        password: String,
        completion: @escaping ((Result<MarketItem, MarketItemDetailUseCaseError>) -> Void)
    ) {
        shouldFailWithFailedResponse
            ? completion(.failure(.networkError(NetworkManagerError.gotFailedResponse(statusCode: 404))))
            : completion(.success(TestAssets.Expected.detailMarketItem))
    }
    
    func verifyPassword(
        itemID: Int,
        password: String,
        completion: @escaping ((Result<MarketItem, MarketItemDetailUseCaseError>) -> Void)
    ) {
        shouldFailWithFailedResponse
            ? completion(.failure(.networkError(NetworkManagerError.gotFailedResponse(statusCode: 404))))
            : completion(.success(TestAssets.Expected.detailMarketItem))
    }
}
