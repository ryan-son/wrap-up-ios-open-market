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

	private let useCase: MarketItemRegisterUseCase
	private var marketItem: MarketItem?
	private var title: String?
	private var imageURLs: [URL] = []
	private var currency: String?
	private var price: String?
	private var discountedPrice: String?
	private var stock: String?
    private var password: String?
	private var descriptions: String?

	// MARK: Initializers

    init(marketItem: MarketItem? = nil, useCase: MarketItemRegisterUseCase = MarketItemRegisterUseCase()) {
        self.marketItem = marketItem
        self.useCase = useCase
    }

	// MARK: Data binding methods

    func bind(_ listener: @escaping ((State) -> Void)) {
        self.listener = listener
    }

	func upload(_ item: MultipartUploadable, by method: NetworkManager.UploadHTTPMethod) {
		let path  = method == .post ? EndPoint.uploadItem.path : EndPoint.item(id: marketItem?.id ?? .zero).path

        useCase.upload(item, to: path, method: method) { [weak self] result in
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

	func setMarketItemInfo(of category: PlaceholderTextView.TextViewType, with text: String) {
		switch category {
		case .title:
			self.title = text
		case .price:
			self.price = text
		case .discountedPrice:
			self.discountedPrice = text
		case .stock:
			self.stock = text
		case .password:
			self.password = text
		case .descriptions:
			self.descriptions = text
		}
	}

	func setMarketItemCurrency(with currency: String) {
		self.currency = currency
	}

	func marketItemToSubmit() -> MultipartUploadable? {
		if marketItem == nil {
			return createPostMarketItem()
		} else {
			return createPatchMarketItem()
		}
	}

	private func createPostMarketItem() -> PostMarketItem? {
		guard let password = password,
			  let title = title,
			  let descriptions = descriptions,
			  let priceString = price,
			  let price = Int(priceString),
			  let currency = currency,
			  let stockString = stock,
			  let stock = Int(stockString) else { return nil }

		return PostMarketItem(title: title,
							  descriptions: descriptions,
							  price: price,
							  currency: currency,
							  stock: stock,
							  discountedPrice: discountedPrice == nil ? nil : Int(discountedPrice!),
							  images: imageURLs,
							  password: password)
	}

	private func createPatchMarketItem() -> PatchMarketItem? {
		guard let password = password else { return nil }
		return PatchMarketItem(title: title,
							   descriptions: descriptions,
							   price: price == nil ? nil : Int(price!),
							   currency: currency,
							   stock: stock == nil ? nil : Int(stock!),
							   discountedPrice: discountedPrice == nil ? nil : Int(discountedPrice!),
							   images: imageURLs,
							   password: password)
	}
}
