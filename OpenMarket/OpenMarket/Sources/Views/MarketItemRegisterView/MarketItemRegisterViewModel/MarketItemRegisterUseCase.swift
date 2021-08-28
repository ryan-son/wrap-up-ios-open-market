//
//  MarketItemRegisterUseCase.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/08/29.
//

import Foundation

enum MarketItemRegisterUseCaseError: Error {

    case emptyPath
}

protocol MarketItemRegisterUseCaseProtocol {

    // update (PATCH)
    // register (POST)
}

final class MarketItemRegisterUseCase {

    private let networkManager: NetworkManageable

    init(networkManager: NetworkManageable) {
        self.networkManager = networkManager
    }
}
