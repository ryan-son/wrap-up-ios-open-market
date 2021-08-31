//
//  MarketItemRegisterViewModel.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/08/29.
//

import Foundation

final class MarketItemRegisterViewModel {

    enum State {
        case empty
        case register
        case edit
        case addImage
        case error(Error)
    }

    var marketItem: MarketItem?
    var images: [URL] = []
    var password: String?
    private let useCase: MarketItemRegisterUseCase
    private var listener: ((State) -> Void)?
    private var state: State = .empty {
        didSet {
            DispatchQueue.main.async {
                self.listener?(self.state)
            }
        }
    }

    init(marketItem: MarketItem? = nil, useCase: MarketItemRegisterUseCase = MarketItemRegisterUseCase()) {
        self.marketItem = marketItem
        self.useCase = useCase
    }

    func bind(_ listener: @escaping ((State) -> Void)) {
        self.listener = listener
    }

    func upload(by method: NetworkManager.UploadHTTPMethod) {
        let path  = EndPoint.uploadItem.path
        guard let marketItem = marketItem,
              let password = password else { return }
        let uploadItem: MultipartUploadable

        switch method {
        case .post:
            uploadItem = PostMarketItem(from: marketItem, images: images, password: password)
        default:
            uploadItem = PatchMarketItem(from: marketItem, images: images, password: password)
        }

        useCase.upload(uploadItem, to: path, method: method) { [weak self] result in
            switch result {
            case .success(let marketItem):
                self?.marketItem = marketItem
                print(marketItem)
            case .failure(let error):
                self?.state = .error(error)
            }
        }
    }
}
