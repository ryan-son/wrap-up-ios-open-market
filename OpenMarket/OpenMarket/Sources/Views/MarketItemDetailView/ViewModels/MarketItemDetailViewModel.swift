//
//  MarketItemDetailViewModel.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/08/28.
//

import Foundation
import UIKit.UIImage

final class MarketItemDetailViewModel {

	// MARK: View model type

    struct MetaData {
        let title: String
        let descriptions: String
        let hasDiscountedPrice: Bool
        let discountedPrice: NSAttributedString
        let price: String
        let isOutOfStock: Bool
        let stock: String
        let numberOfImages: Int
    }

	// MARK: Binder state

	enum State {
		case empty
		case fetch(MarketItemDetailViewModel.MetaData)
		case fetchImage(UIImage, Int)
        case verify(MarketItem, password: String)
        case failedToStartEdit
		case delete
		case deleteFailed
		case error(MarketItemDetailUseCaseError)
	}

	// MARK: Binder and its state

	private var listener: ((State) -> Void)?
	private var state: State = .empty {
		willSet {
			listenerSemaphore.wait()
		}
		didSet {
			DispatchQueue.main.async {
				self.listener?(self.state)
				self.listenerSemaphore.signal()
			}
		}
	}

	// MARK: Bound properties

	private(set) var marketItem: MarketItem?
	private(set) var images: [UIImage] = []

	// MARK: Properties

    private let marketItemID: Int
	private let useCase: MarketItemDetailUseCaseProtocol

    // MARK: Asynchronous task handlers

    private let semaphore = DispatchSemaphore(value: 1)
    private let listenerSemaphore = DispatchSemaphore(value: 1)

    // MARK: Data tasks

    private var itemDetailTask: URLSessionDataTask?
    private var detailImageTasks: [URLSessionDataTask?] = []

	// MARK: Initializers

    init(marketItemID: Int, useCase: MarketItemDetailUseCaseProtocol = MarketItemDetailUseCase()) {
        self.marketItemID = marketItemID
        self.useCase = useCase
    }

	// MARK: Binding methods

    func bind(_ listener: @escaping (State) -> Void) {
        self.listener = listener
    }

    func fire() {
        let serialQueue = DispatchQueue(label: Style.serialQueueName)
        serialQueue.async {
            self.fetchMarketItemDetail()

            self.semaphore.wait()
            guard let images = self.marketItem?.images else { return }
            self.semaphore.signal()

            for (index, path) in images.enumerated() {
                self.fetchImage(for: index, from: path)
            }
        }
    }

    private func fetchMarketItemDetail() {
        semaphore.wait()
        itemDetailTask = useCase.fetchMarketItemDetail(itemID: marketItemID) { [weak self] result in
            self?.semaphore.signal()
            switch result {
            case .success(let marketItem):
                self?.marketItem = marketItem
                guard let metaData = self?.setupMetaData(with: marketItem) else { return }
                self?.state = .fetch(metaData)
            case .failure(let error):
                self?.state = .error(error)
            }
        }
    }

    private func fetchImage(for index: Int, from path: String) {
        semaphore.wait()
        let imageTask = useCase.fetchImage(from: path) { [weak self] result in
            self?.semaphore.signal()
            switch result {
            case .success(let image):
                self?.images.append(image)
                self?.state = .fetchImage(image, index)
            case .failure(let error):
                self?.state = .error(.networkError(error))
            }
        }
        detailImageTasks.append(imageTask)
    }

    private func setupMetaData(with marketItem: MarketItem) -> MetaData {
        let hasDiscountedPrice: Bool = marketItem.discountedPrice != nil
        let discountedPrice = hasDiscountedPrice
            ? "\(marketItem.currency) \(marketItem.price.priceFormatted())".strikeThrough()
            : NSAttributedString()
        let price: String = hasDiscountedPrice
            ? "\(marketItem.currency) \(marketItem.discountedPrice?.priceFormatted() ?? "")"
            : "\(marketItem.currency) \(marketItem.price.priceFormatted())"
        let isOutOfStock: Bool = marketItem.stock == .zero
        let stock: String

        if isOutOfStock {
            stock = Style.outOfStockText
        } else if marketItem.stock > Style.stockLabelUpperLimit {
            stock = "\(Style.stockLabelPrefix) \(Style.stockLabelUpperLimitText)"
        } else {
            stock = "\(Style.stockLabelPrefix) \(marketItem.stock)"
        }

        let metaData = MetaData(title: marketItem.title,
                                descriptions: marketItem.descriptions ?? "",
                                hasDiscountedPrice: hasDiscountedPrice,
                                discountedPrice: discountedPrice,
                                price: price,
                                isOutOfStock: isOutOfStock,
                                stock: stock,
                                numberOfImages: marketItem.images?.count ?? .zero)
        return metaData
    }

    func verifyPassword(_ password: String) {
        useCase.verifyPassword(itemID: marketItemID, password: password) { [weak self] result in
            switch result {
            case .success(let marketItem):
                self?.marketItem = marketItem
                self?.state = .verify(marketItem, password: password)
            case .failure(let error):
                if case let .networkError(someError) = error,
                   let anyError = someError as? NetworkManagerError,
                   case let .gotFailedResponse(statusCode) = anyError,
                   statusCode == NetworkManager.notFoundStatusCode {
                    self?.state = .failedToStartEdit
                } else {
                    self?.state = .error(error)
                }
            }
        }
    }

	func deleteMarketItem(with password: String) {
		useCase.deleteMarketItem(itemID: marketItemID, password: password) { [weak self] result in
			switch result {
			case .success:
                self?.state = .delete
			case .failure(let error):
                if case let .networkError(someError) = error,
                   let anyError = someError as? NetworkManagerError,
                   case let .gotFailedResponse(statusCode) = anyError,
                   statusCode == NetworkManager.notFoundStatusCode {
                    self?.state = .deleteFailed
                } else {
                    self?.state = .error(error)
                }
			}
		}
	}

    func refresh() {
        marketItem = nil
        images.removeAll()
        fire()
    }

    func cancelDataTasks() {
        itemDetailTask?.cancel()
        detailImageTasks.forEach { $0?.cancel() }
    }
}

// MARK: - Namespaces

extension MarketItemDetailViewModel {

	private enum Style {

        static let serialQueueName: String = "serial"
		static let targetImageSize = CGSize(width: 50, height: 50)
		static let outOfStockText: String = "품절"
		static let stockLabelPrefix: String = "재고:"
		static let stockLabelUpperLimit: Int = 999
		static let stockLabelUpperLimitText: String = "999+"
	}
}
