//
//  MarketItemListUseCase.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/08/24.
//

import Foundation

enum MarketItemListUseCaseError: Error {

    case NetworkError(Error)
    case selfNotFound
    case unknown(Error)
    case lastPage
}

protocol MarketItemListUseCaseProtocol {

    @discardableResult
    func fetchItems(
        completion: @escaping (Result<[MarketItem], MarketItemListUseCaseError>) -> Void
    ) -> URLSessionDataTask?
    func refresh()
}

final class MarketItemListUseCase: MarketItemListUseCaseProtocol {

	// MARK: Properties

    private let networkManager: NetworkManageable
    private var isFetching: Bool = false
    private var isLastPage: Bool = false
    private var page: Int = 1
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

	// MARK: Initializers

    init(networkManager: NetworkManageable = NetworkManager()) {
        self.networkManager = networkManager
    }

	// MARK: Use case methods

    @discardableResult
    func fetchItems(
        completion: @escaping (Result<[MarketItem], MarketItemListUseCaseError>) -> Void
    ) -> URLSessionDataTask? {
        if isFetching || isLastPage { return nil }
        isFetching = true

        let path = EndPoint.items(page: page).path
        let task = networkManager.fetch(from: path) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    guard let marketItemList = try self?.decoder.decode(MarketItemList.self, from: data) else {
                        completion(.failure(.selfNotFound))
                        return
                    }
                    if marketItemList.items.isEmpty {
                        self?.isLastPage = true
                        completion(.failure(.lastPage))
                        return
                    }
                    self?.page += 1
                    completion(.success(marketItemList.items))
                } catch {
                    completion(.failure(.unknown(error)))
                }
            case .failure(let error):
                completion(.failure(.NetworkError(error)))
            }
            self?.isFetching = false
        }

        task?.resume()
        return task
    }

    func refresh() {
        isFetching = false
        isLastPage = false
        page = 1
    }
}
