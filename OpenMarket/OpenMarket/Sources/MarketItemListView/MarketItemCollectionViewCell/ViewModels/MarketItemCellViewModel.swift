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

    struct MetaData {
        let title: String
        var thumbnail: UIImage?
        let hasDiscountedPrice: Bool
        let discountedPrice: NSAttributedString
        let price: String
        let isOutOfStock: Bool
        let stock: String
    }

    enum State {
        case empty
        case update(MarketItemCellViewModel.MetaData)
        case error(MarketItemCellViewModelError)
    }

    private let marketItem: MarketItem
    private let useCase: ThumbnailUseCaseProtocol
    private var thumbnailTask: URLSessionDataTask?
    private var listener: ((State) -> Void)?
    private var state: State = .empty {
        didSet {
            DispatchQueue.main.async {
                self.listener?(self.state)
            }
        }
    }
    private let imageSize = CGSize(width: 50, height: 50)

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
            guard let self = self else { return }
            switch result {
            case .success(let thumbnail):
                guard case var .update(metaData) = self.state else { return }
                metaData.thumbnail = thumbnail?.resizedImage(targetSize: self.imageSize)
                self.state = .update(metaData)
            case .failure(let error):
                self.state = .error(.useCaseError(error))
            }
        }
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
            stock = "품절"
        } else if marketItem.stock > 999 {
            stock = "재고: 999+"
        } else {
            stock = "재고: \(marketItem.stock)"
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
