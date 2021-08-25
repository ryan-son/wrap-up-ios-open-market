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
        let task = networkManager.fetchData(from: path) { result in
            switch result {
            case .success(let data):
                let thumbnail = UIImage(data: data)
                completion(.success(thumbnail))
            case .failure(let error):
                completion(.failure(.networkError(error)))
            }
        }
        task?.resume()
        return task
    }
}
