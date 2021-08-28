//
//  MarketItemDetailViewModel.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/08/28.
//

import Foundation
import UIKit.UIImage

final class MarketItemDetailViewModel {

    enum State {
        case empty
        case fetch(MarketItemDetailViewModel.MetaData)
        case fetchImage(UIImage, Int)
        case update
        case error(MarketItemDetailUseCaseError)
    }

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

    private enum Style {

        static let targetImageSize = CGSize(width: 50, height: 50)
        static let outOfStockText: String = "품절"
        static let stockLabelPrefix: String = "재고:"
        static let stockLabelUpperLimit: Int = 999
        static let stockLabelUpperLimitText: String = "999+"
    }

    private let marketItemID: Int
    private let useCase: MarketItemDetailUseCaseProtocol
    private var listener: ((State) -> Void)?
    private var marketItem: MarketItem?
    private(set) var images: [UIImage] = []
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
    private let semaphore = DispatchSemaphore(value: 1)
    private let listenerSemaphore = DispatchSemaphore(value: 1)

    init(marketItemID: Int, useCase: MarketItemDetailUseCaseProtocol = MarketItemDetailUseCase()) {
        self.marketItemID = marketItemID
        self.useCase = useCase
    }

    func bind(_ listener: @escaping (State) -> Void) {
        self.listener = listener
    }

    func fire() {
        let serialQueue = DispatchQueue(label: "serial")
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

    func fetchMarketItemDetail() {
        semaphore.wait()
        useCase.fetchMarketItemDetail(itemID: marketItemID) { [weak self] result in
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

    func fetchImage(for index: Int, from path: String) {
        semaphore.wait()
        useCase.fetchImage(from: path) { [weak self] result in
            self?.semaphore.signal()
            switch result {
            case .success(let image):
                self?.images.append(image)
                self?.state = .fetchImage(image, index)
            case .failure(let error):
                self?.state = .error(.networkError(error))
            }
        }
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
}
