//
//  StubMarketItemDetailUseCase.swift
//  OpenMarketTests
//
//  Created by Ryan-Son on 2021/09/06.
//

import UIKit.UIImage
@testable import OpenMarket

final class StubMarketItemDetailUseCase: MarketItemDetailUseCaseProtocol {

    let session: URLSession
    var shouldFailWithFailedResponse: Bool = false

    init() {
        let configuration: URLSessionConfiguration = .ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: configuration)

        MockURLProtocol.loadingHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
                return (response, nil)
        }
    }

    func fetchMarketItemDetail(
        itemID: Int,
        completion: @escaping ((Result<MarketItem, MarketItemDetailUseCaseError>) -> Void)
    ) -> URLSessionDataTask? {
        completion(.success(TestAssets.Expected.detailMarketItem))
        return session.dataTask(with: URL(string: "https://test.com")!)
    }
    
    func fetchImage(
        from path: String,
        completion: @escaping (Result<UIImage, MarketItemDetailUseCaseError>) -> Void
    ) -> URLSessionDataTask? {
        completion(.success(TestAssets.Expected.image))
        return session.dataTask(with: URL(string: "https://test.com")!)
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
