//
//  MarketItemListViewModel.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/08/24.
//

import Foundation

enum MarketItemListViewModelError: Error {

    case useCaseError(Error)
}

final class MarketItemListViewModel {

    enum State {
        case empty
        case fetch(indexPaths: [IndexPath])
        case insert
        case delete
        case error(MarketItemListViewModelError)
    }

    private let useCase: MarketItemListUseCaseProtocol
    private var listener: ((State) -> Void)?
    private var marketItems: [MarketItem] = [] {
        didSet {
//            oldValue.count < items.count
//                ? changed?(.fetch(indices: [oldValue.count...items.count]))
//                : changed?(.delete)
            state = .fetch(indexPaths: (oldValue.count ..< marketItems.count).map {
                return IndexPath(item: $0, section: .zero)
            })
        }
    }
    private var state: State = .empty {
        didSet {
            listener?(state)
        }
    }

    init(useCase: MarketItemListUseCaseProtocol = MarketItemListUseCase()) {
        self.useCase = useCase
    }

    func bind(_ listener: @escaping ((State) -> Void)) {
        self.listener = listener
    }

    func list() {
        useCase.fetchItems { [weak self] result in
            switch result {
            case .success(let marketItems):
                self?.marketItems.append(contentsOf: marketItems)
            case .failure(let error):
                self?.state = .error(.useCaseError(error))
            }
        }
    }
}
