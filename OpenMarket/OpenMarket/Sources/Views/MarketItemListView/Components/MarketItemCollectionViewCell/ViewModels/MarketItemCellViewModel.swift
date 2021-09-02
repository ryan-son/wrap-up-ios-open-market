//
//  MarketItemCellViewModel.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/08/25.
//

import Foundation
import UIKit.UIImage

enum MarketItemCellViewModelError: Error {

    case useCaseError(ThumbnailUseCaseError)
    case emptyPath
}

final class MarketItemCellViewModel {

	// MARK: View model type
    struct MetaData {
        let title: String
        var thumbnail: UIImage?
        let hasDiscountedPrice: Bool
        let discountedPrice: NSAttributedString
        let price: String
        let isOutOfStock: Bool
        let stock: String
    }

	// MARK: Binder state

    enum State {
        case empty
        case update(MarketItemCellViewModel.MetaData)
        case error(MarketItemCellViewModelError)
    }

	// MARK: Binder and state

	private var listener: ((State) -> Void)?
	private var state: State = .empty {
		didSet {
			DispatchQueue.main.async {
				self.listener?(self.state)
			}
		}
	}

    private let marketItem: MarketItem
    private let useCase: ThumbnailUseCaseProtocol
    private var thumbnailTask: URLSessionDataTask?

    init(marketItem: MarketItem, thumbnailUseCase: ThumbnailUseCaseProtocol = ThumbnailUseCase()) {
        self.marketItem = marketItem
        self.useCase = thumbnailUseCase
    }

    func bind(_ listener: @escaping (State) -> Void) {
        self.listener = listener
    }

    func fire() {
        setMetaDataTexts()
        setMetaDataThumbnail()
    }

    private func setMetaDataThumbnail() {
        guard let path = marketItem.thumbnails.first else {
            state = .error(.emptyPath)
            return
        }

        thumbnailTask = useCase.fetchThumbnail(from: path) { [weak self] result in
            switch result {
            case .success(let thumbnail):
                guard case var .update(metaData) = self?.state else { return }
                metaData.thumbnail = thumbnail
                self?.state = .update(metaData)
            case .failure(let error):
                self?.state = .error(.useCaseError(error))
            }
        }
    }

    func prefetchThumbnail() {
        guard let path = marketItem.thumbnails.first else { return }
        thumbnailTask = useCase.fetchThumbnail(from: path) { _ in }
    }

    func cancelThumbnailRequest() {
        thumbnailTask?.cancel()
    }

    private func setMetaDataTexts() {
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
                                thumbnail: nil,
                                hasDiscountedPrice: hasDiscountedPrice,
                                discountedPrice: discountedPrice,
                                price: price,
                                isOutOfStock: isOutOfStock,
                                stock: stock)
        state = .update(metaData)
    }
}

// MARK: - Namespaces

extension MarketItemCellViewModel {

	private enum Style {

		static let outOfStockText: String = "품절"
		static let stockLabelPrefix: String = "재고:"
		static let stockLabelUpperLimit: Int = 999
		static let stockLabelUpperLimitText: String = "999+"
	}
}
