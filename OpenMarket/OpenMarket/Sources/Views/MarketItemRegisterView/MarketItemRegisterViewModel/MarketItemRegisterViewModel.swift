//
//  MarketItemRegisterViewModel.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/08/29.
//

import Foundation
import UIKit.UIImage

final class MarketItemRegisterViewModel {

	// MARK: Binder state

    enum State {
        case empty
        case register
        case edit
        case appendImage(Int)
        case deleteImage(Int)
        case error(Error)
    }

	// MARK: Binder and its state

	private var listener: ((State) -> Void)?
	private var state: State = .empty {
		didSet {
			DispatchQueue.main.async {
				self.listener?(self.state)
			}
		}
	}

    // MARK: Bound properties

    private(set) var images: [UIImage] = [] {
        didSet {
            let difference = images.difference(from: oldValue)

            for change in difference {
                switch change {
                case let .insert(offset, _, _):
                    state = .appendImage(offset)
                case let .remove(offset, _, _):
                    state = .deleteImage(offset)
                }
            }
        }
    }

	// MARK: Properties

	private var marketItem: MarketItem?
    private var imageURLs: [URL] = []
    private var password: String?
    private let useCase: MarketItemRegisterUseCase


	// MARK: Initializers

    init(marketItem: MarketItem? = nil, useCase: MarketItemRegisterUseCase = MarketItemRegisterUseCase()) {
        self.marketItem = marketItem
        self.useCase = useCase
    }

	// MARK: Data binding methods

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
