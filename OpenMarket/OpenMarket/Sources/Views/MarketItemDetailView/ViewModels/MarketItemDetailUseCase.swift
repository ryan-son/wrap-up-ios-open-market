//
//  MarketItemDetailUseCase.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/08/28.
//

import Foundation
import UIKit.UIImage

enum MarketItemDetailUseCaseError: Error {

    case networkError(Error)
    case selfNotFound
    case notAnImageOrEmptyData
	case encodingError(Error)
    case unknown(Error)
}

protocol MarketItemDetailUseCaseProtocol {

    @discardableResult
    func fetchMarketItemDetail(
        itemID: Int,
        completion: @escaping ((Result<MarketItem, MarketItemDetailUseCaseError>) -> Void)
    ) -> URLSessionDataTask?

    @discardableResult
    func fetchImage(
        from path: String,
        completion: @escaping(Result<UIImage, MarketItemDetailUseCaseError>) -> Void
    ) -> URLSessionDataTask?

	@discardableResult
	func deleteMarketItem(
		itemID: Int,
		password: String,
		completion: @escaping((Result<Int, MarketItemDetailUseCaseError>) -> Void)
	) -> URLSessionDataTask?
}

final class MarketItemDetailUseCase: MarketItemDetailUseCaseProtocol {

	// MARK: Properties

    private let networkManager: NetworkManageable
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
	private let encoder: JSONEncoder = {
		let encoder = JSONEncoder()
		encoder.keyEncodingStrategy = .convertToSnakeCase
		return encoder
	}()

	// MARK: Initializers

    init(networkManager: NetworkManageable = NetworkManager()) {
        self.networkManager = networkManager
    }

	// MARK: Use case methods

    @discardableResult
    func fetchMarketItemDetail(
        itemID: Int,
        completion: @escaping ((Result<MarketItem, MarketItemDetailUseCaseError>) -> Void)
    ) -> URLSessionDataTask? {
        let path = EndPoint.item(id: itemID).path

        let task = networkManager.fetch(from: path) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    guard let marketItem = try self?.decoder.decode(MarketItem.self, from: data) else {
                        completion(.failure(.selfNotFound))
                        return
                    }
                    completion(.success(marketItem))
                } catch {
                    completion(.failure(.unknown(error)))
                }
            case .failure(let error):
                completion(.failure(.networkError(error)))
            }
        }
        task?.resume()
        return task
    }

    @discardableResult
    func fetchImage(
        from path: String,
        completion: @escaping(Result<UIImage, MarketItemDetailUseCaseError>) -> Void
    ) -> URLSessionDataTask? {
        let task = networkManager.fetch(from: path) { result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else {
                    completion(.failure(.notAnImageOrEmptyData))
                    return
                }
                completion(.success(image))
            case .failure(let error):
                completion(.failure(.networkError(error)))
            }
        }
        task?.resume()
        return task
    }

	@discardableResult
	func deleteMarketItem(
		itemID: Int,
		password: String,
		completion: @escaping((Result<Int, MarketItemDetailUseCaseError>) -> Void)
	) -> URLSessionDataTask? {
		let path = EndPoint.item(id: itemID).path
		let deleteMarketItem = DeleteMarketItem(password: password)
		do {
			let deleteData = try encoder.encode(deleteMarketItem)

			let task = networkManager.delete(deleteData, at: path) { result in
				switch result {
				case .success(let statusCode):
					completion(.success(statusCode))
				case .failure(let error):
					completion(.failure(.networkError(error)))
				}
			}
			task?.resume()
			return task
		} catch {
			completion(.failure(.encodingError(error)))
			return nil
		}
	}
}
