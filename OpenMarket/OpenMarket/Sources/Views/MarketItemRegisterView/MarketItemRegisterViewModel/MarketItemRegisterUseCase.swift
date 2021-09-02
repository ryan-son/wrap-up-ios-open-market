//
//  MarketItemRegisterUseCase.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/08/29.
//

import Foundation

enum MarketItemRegisterUseCaseError: Error {

    case networkError(Error)
    case emptyPath
    case selfNotFound
    case unknown(Error)
}

protocol MarketItemRegisterUseCaseProtocol {

    @discardableResult
    func upload(
        _ marketItem: MultipartUploadable,
        to path: String, method: NetworkManager.UploadHTTPMethod,
        completion: @escaping ((Result<MarketItem, MarketItemRegisterUseCaseError>) -> Void)
    ) -> URLSessionDataTask?
}

final class MarketItemRegisterUseCase {

	// MARK: Properties

    private let networkManager: NetworkManageable
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
    func upload(
        _ marketItem: MultipartUploadable,
        to path: String, method: NetworkManager.UploadHTTPMethod,
        completion: @escaping ((Result<MarketItem, MarketItemRegisterUseCaseError>) -> Void)
    ) -> URLSessionDataTask? {
        let task = networkManager.multipartUpload(marketItem, to: path, method: method) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    guard let registered = try self?.decoder.decode(MarketItem.self, from: data) else {
                        completion(.failure(.selfNotFound))
                        return
                    }
                    completion(.success((registered)))
                } catch {
                    completion(.failure(.unknown(error)))
                }
            case .failure(let error):
                completion(.failure(.networkError(error)))
            }
        }
        return task
    }
}
