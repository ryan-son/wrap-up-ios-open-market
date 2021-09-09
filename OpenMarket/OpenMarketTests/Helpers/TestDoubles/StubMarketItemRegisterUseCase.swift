//
//  StubMarketItemRegisterUseCase.swift
//  OpenMarketTests
//
//  Created by Ryan-Son on 2021/09/06.
//

import Foundation
@testable import OpenMarket

final class StubMarketItemRegisterUseCase: MarketItemRegisterUseCaseProtocol {

    private(set) var uploadCallCount: Int = .zero

    func upload(
        _ marketItem: MultipartUploadable,
        to path: String,
        method: NetworkManager.UploadHTTPMethod,
        completion: @escaping ((Result<MarketItem, MarketItemRegisterUseCaseError>) -> Void)
    ) {
        uploadCallCount += 1
        completion(.success(TestAssets.Expected.detailMarketItem))
    }
}
