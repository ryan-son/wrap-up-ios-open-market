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
        case startEdit(title: String, currency: String, price: String, discountedPrice: String?, stock: String, password: String, descriptions: String)
        case register(MarketItem)
        case update(MarketItem)
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

	private var marketItem: MarketItem? {
		didSet {
			if oldValue == nil {
                guard let marketItem = marketItem else { return }
                state = .register(marketItem)
			} else {
                guard let marketItem = marketItem else { return }
                state = .update(marketItem)
			}
		}
	}

	// MARK: Properties

	private let useCase: MarketItemRegisterUseCase
	private var title: String?
	private var currency: String?
	private var price: String?
	private var discountedPrice: String?
	private var stock: String?
    private var password: String?
	private var descriptions: String?

    private let targetImageSizeInKB: Int = 300

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
            case .failure(let error):
                self?.state = .error(error)
            }
        }
    }

    func appendImage(_ image: UIImage) {
        images.append(image)
    }

    func removeImage(at index: Int) {
        images.remove(at: index)
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
        let images = images.compactMap { $0.compress(to: targetImageSizeInKB) }

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
							  images: images,
							  password: password)
	}

	private func createPatchMarketItem() -> PatchMarketItem? {
		guard let password = password else { return nil }
        let images = images.compactMap { $0.compress(to: targetImageSizeInKB) }
		return PatchMarketItem(title: title,
							   descriptions: descriptions,
							   price: price == nil ? nil : Int(price!),
							   currency: currency,
							   stock: stock == nil ? nil : Int(stock!),
							   discountedPrice: discountedPrice == nil ? nil : Int(discountedPrice!),
							   images: images.isEmpty ? nil : images,
							   password: password)
	}

    func startEditing(with password: String) {
        guard let marketItem = marketItem else { return }
        self.password = password
        state = .startEdit(title: marketItem.title,
                           currency: marketItem.currency,
                           price: String(marketItem.price),
                           discountedPrice: marketItem.discountedPrice == nil ? nil : String(marketItem.discountedPrice!),
                           stock: String(marketItem.stock),
                           password: password,
                           descriptions: marketItem.descriptions ?? "")
    }
}
