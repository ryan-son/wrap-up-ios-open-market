//
//  MarketItemRegisterViewModel.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/08/29.
//

import Foundation
import UIKit.UIImage

final class MarketItemRegisterViewModel {

    enum State {
        case empty
        case register
        case edit
        case appendImage(Int, UIImage)
        case deleteImage(Int)
        case error(Error)
    }

    private var marketItem: MarketItem?
    private(set) var images: [UIImage] = [] {
        didSet {
            let difference = images.difference(from: oldValue)

            for change in difference {
                switch change {
                case let .insert(offset, image, _):
                    state = .appendImage(offset, image)
                case let .remove(offset, _, _):
                    state = .deleteImage(offset)
                }
            }
        }
    }
    private var imageURLs: [URL] = []
    private var password: String?
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
            uploadItem = PostMarketItem(from: marketItem, images: imageURLs, password: password)
        case .patch:
            uploadItem = PatchMarketItem(from: marketItem, images: imageURLs, password: password)
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

    func appendImage(_ image: UIImage, at url: URL) {
        images.append(image)
        imageURLs.append(url)
    }

    func removeImage(at index: Int) {
        images.remove(at: index)
        imageURLs.remove(at: index)
    }
}
