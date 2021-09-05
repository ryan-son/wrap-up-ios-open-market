//
//  StubThumbnailUseCase.swift
//  OpenMarketTests
//
//  Created by Ryan-Son on 2021/09/05.
//

import UIKit.UIImage
@testable import OpenMarket

final class StubThumbnailUseCase: ThumbnailUseCaseProtocol {

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

    func fetchThumbnail(from path: String, completion: @escaping (Result<UIImage?, ThumbnailUseCaseError>) -> Void) -> URLSessionDataTask? {
        let url = NSURL(string: TestAssets.Expected.thumbnailURLString)!
        ThumbnailUseCase.sharedCache.setObject(TestAssets.Expected.image, forKey: url)
        completion(.success(TestAssets.Expected.image))
        return session.dataTask(with: URL(string: "https://test.com")!)
    }
}
