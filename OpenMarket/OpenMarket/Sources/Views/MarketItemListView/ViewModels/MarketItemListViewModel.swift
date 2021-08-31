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
        case fetched(indexPaths: [IndexPath])
        case insert
        case delete
        case refresh
        case error(MarketItemListViewModelError)
    }

    private let useCase: MarketItemListUseCaseProtocol
    private var listener: ((State) -> Void)?
    private(set) var marketItems: [MarketItem] = [] {
        didSet {
            switch marketItems.count {
            case .zero:
                state = .refresh
            case oldValue.count...:
                let indexPaths = (oldValue.count ..< marketItems.count).map { IndexPath(item: $0, section: .zero) }
                state = .fetched(indexPaths: indexPaths)
            default:
                break
            }
        }
    }
    private var state: State = .empty {
        didSet {
            DispatchQueue.main.async {
                self.listener?(self.state)
            }
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

    func refresh() {
        useCase.refresh()
        ThumbnailUseCase.sharedCache.removeAllObjects()
        marketItems.removeAll()
        list()
    }
}
