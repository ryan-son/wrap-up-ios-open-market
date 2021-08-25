//
//  ThumbnailUseCase.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/08/25.
//

import Foundation
import UIKit.UIImage

enum ThumbnailUseCaseError: Error {

    case networkError(Error)
    case emptyPath
    case emptyData
}

protocol ThumbnailUseCaseProtocol {

    func fetchThumbnail(from path: String,
                        completion: @escaping (Result<UIImage?, ThumbnailUseCaseError>) -> Void) -> URLSessionDataTask?
}

final class ThumbnailUseCase: ThumbnailUseCaseProtocol {

    static var sharedCache = NSCache<NSURL, UIImage>()
    private let networkManager: NetworkManageable

    init(networkManager: NetworkManageable = NetworkManager()) {
        self.networkManager = networkManager
    }

    func fetchThumbnail(
        from path: String,
        completion: @escaping (Result<UIImage?, ThumbnailUseCaseError>) -> Void
    ) -> URLSessionDataTask? {
        guard let cacheKey = NSURL(string: path) else {
            completion(.failure(.emptyPath))
            return nil
        }

        if let cachedThumbnail = ThumbnailUseCase.sharedCache.object(forKey: cacheKey) {
            completion(.success(cachedThumbnail))
            return nil
        }

        let task = networkManager.fetchData(from: path) { result in
            switch result {
            case .success(let data):
                guard let thumbnail = UIImage(data: data) else {
                    completion(.failure(.emptyData))
                    return
                }
                completion(.success(thumbnail))
                ThumbnailUseCase.sharedCache.setObject(thumbnail, forKey: cacheKey)
            case .failure(let error):
                completion(.failure(.networkError(error)))
            }
        }
        task?.resume()
        return task
    }
}
