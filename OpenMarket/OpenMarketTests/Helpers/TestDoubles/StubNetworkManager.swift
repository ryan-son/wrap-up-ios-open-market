//
//  StubNetworkManager.swift
//  OpenMarketTests
//
//  Created by Ryan-Son on 2021/09/05.
//

import Foundation
@testable import OpenMarket

final class StubNetworkManager: NetworkManageable {

    let session: URLSession

    init() {
        let configuration: URLSessionConfiguration = .ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: configuration)

        MockURLProtocol.loadingHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
                return (response, nil)
        }
    }
    
    func fetch(from urlString: String, completion: @escaping (Result<Data, NetworkManagerError>) -> Void) -> URLSessionDataTask? {
        if urlString.contains("/items") {
            completion(.success(TestAssets.Expected.fetchMarketItemListData))
        } else if urlString.contains("/item") {
            completion(.success(TestAssets.Expected.fetchMarketItemDetailData))
        } else if urlString.contains("/thumbnails") || urlString.contains("/images") {
            completion(.success(TestAssets.Dummies.imageData))
        } else {
            completion(.failure(.urlCreationFailed))
        }
        return session.dataTask(with: URL(string: "https://test.com")!)
    }
    
    func multipartUpload(_ marketItem: MultipartUploadable, to urlString: String, method: NetworkManager.UploadHTTPMethod, completion: @escaping ((Result<Data, NetworkManagerError>) -> Void)) {
        if urlString.contains("/item") {
            completion(.success(TestAssets.Expected.fetchMarketItemDetailData))
        } else {
            completion(.failure(.urlCreationFailed))
        }
    }
    
    func delete(_ deleteData: Data, at urlString: String, completion: @escaping ((Result<Data, NetworkManagerError>) -> Void)) {
        if urlString.contains("/item") {
            completion(.success(TestAssets.Expected.fetchMarketItemDetailData))
        } else {
            completion(.failure(.urlCreationFailed))
        }
    }
}
