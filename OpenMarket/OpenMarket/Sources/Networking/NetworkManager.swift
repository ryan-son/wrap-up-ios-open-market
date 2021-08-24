//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/08/24.
//

import Foundation

enum NetworkManagerError: Error {

    case urlCreationFailed
    case requestError(Error)
    case invalidHTTPResponse
    case gotFailedResponse(statusCode: Int)
    case emptyData
}

protocol NetworkManageable {

    func fetchData(from urlString: String,
                   completion: @escaping (Result<Data, NetworkManagerError>) -> Void) -> URLSessionDataTask?
}

final class NetworkManager: NetworkManageable {

    private let session: URLSession
    private let okResponse: Range<Int> = (200 ..< 300)

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchData(from urlString: String,
                   completion: @escaping (Result<Data, NetworkManagerError>) -> Void) -> URLSessionDataTask? {
        guard let url = URL(string: urlString) else {
            completion(.failure(.urlCreationFailed))
            return nil
        }

        let task = session.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                completion(.failure(.requestError(error)))
                return
            }

            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.invalidHTTPResponse))
                return
            }

            guard let okResponse = self?.okResponse,
                  okResponse ~= response.statusCode else {
                completion(.failure(.gotFailedResponse(statusCode: response.statusCode)))
                return
            }

            guard let data = data else {
                completion(.failure(.emptyData))
                return
            }

            completion(.success(data))
        }

        task.resume()
        return task
    }
}
