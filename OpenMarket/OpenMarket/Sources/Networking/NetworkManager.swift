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

	func fetch(from urlString: String,
			   completion: @escaping (Result<Data, NetworkManagerError>) -> Void) -> URLSessionDataTask?
    func multipartUpload(_ marketItem: MultipartUploadable,
                         to urlString: String,
                         method: NetworkManager.UploadHTTPMethod,
                         completion: @escaping ((Result<Data, NetworkManagerError>) -> Void)) -> URLSessionDataTask?
	func delete(_ deleteData: Data,
				at urlString: String,
				completion: @escaping ((Result<Int, NetworkManagerError>) -> Void)) -> URLSessionDataTask?
}

final class NetworkManager: NetworkManageable {

    enum UploadHTTPMethod: String {
        case post, patch
    }

	// MARK: Properties

    private let session: URLSession
    static let okStatusCode: Range<Int> = (200 ..< 300)
	static let notFoundStatusCode: Int = 404

	// MARK: Initializers

    init(session: URLSession = .shared) {
        self.session = session
    }

	// MARK: Networking methods

	func fetch(from urlString: String, completion: @escaping (Result<Data, NetworkManagerError>) -> Void) -> URLSessionDataTask? {
        guard let url = URL(string: urlString) else {
            completion(.failure(.urlCreationFailed))
            return nil
        }

        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.requestError(error)))
                return
            }

            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.invalidHTTPResponse))
                return
            }

			guard NetworkManager.okStatusCode ~= response.statusCode else {
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

    func multipartUpload(_ marketItem: MultipartUploadable,
                         to urlString: String,
                         method: UploadHTTPMethod = .post,
                         completion: @escaping ((Result<Data, NetworkManagerError>) -> Void)) -> URLSessionDataTask? {
        guard let url = URL(string: urlString) else {
            completion(.failure(.urlCreationFailed))
            return nil
        }

        let multipartFormData = MultipartFormData()
        let encoded: Data = multipartFormData.encode(parameters: marketItem.asDictionary)

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue.uppercased()
        request.setValue(
            multipartFormData.contentType,
            forHTTPHeaderField: "Content-Type"
        )
        request.httpBody = encoded

        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.requestError(error)))
                return
            }

            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.invalidHTTPResponse))
                return
            }

            guard NetworkManager.okStatusCode ~= response.statusCode else {
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

	func delete(_ deleteData: Data,
				at urlString: String,
				completion: @escaping ((Result<Int, NetworkManagerError>) -> Void)) -> URLSessionDataTask? {
		guard let url = URL(string: urlString) else {
			completion(.failure(.urlCreationFailed))
			return nil
		}

		var request = URLRequest(url: url)
		request.httpMethod = "DELETE"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpBody = deleteData

		let task = session.dataTask(with: request) { _, response, error in
			if let error = error {
				completion(.failure(.requestError(error)))
				return
			}

			guard let response = response as? HTTPURLResponse else {
				completion(.failure(.invalidHTTPResponse))
				return
			}

			guard NetworkManager.okStatusCode ~= response.statusCode ||
					response.statusCode == NetworkManager.notFoundStatusCode else {
				completion(.failure(.gotFailedResponse(statusCode: response.statusCode)))
				return
			}

			completion(.success(response.statusCode))
		}
		task.resume()
		return task
	}
}
