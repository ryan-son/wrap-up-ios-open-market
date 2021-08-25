//
//  MarketItemListViewController.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/08/24.
//

import UIKit

final class MarketItemListViewController: UIViewController {

    private let viewModel = MarketItemListViewModel()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(MarketItemListCollectionViewCell.self,
                                forCellWithReuseIdentifier: MarketItemListCollectionViewCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViews()
        setupDelegates()
        bindWithViewModel()
        viewModel.list()
    }

    private func setupDelegates() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .systemBackground
        navigationController?.navigationBar.isTranslucent = false
        title = "Open Market"
    }

    private func setupViews() {
        view.addSubview(collectionView)
    }

    private func bindWithViewModel() {
        viewModel.bind { [weak self] state in
            switch state {
            case .fetch(let indexPaths):
                DispatchQueue.main.async {
                    self?.collectionView.insertItems(at: indexPaths)
                }
            default:
                break
            }
        }
    }
}

extension MarketItemListViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.marketItems.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let listCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MarketItemListCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? MarketItemListCollectionViewCell else { return MarketItemListCollectionViewCell() }

        let marketItem = viewModel.marketItems[indexPath.item]
        let marketItemCellViewModel = MarketItemCellViewModel(marketItem: marketItem)

        listCell.bind(with: marketItemCellViewModel)
        listCell.fire()

        return listCell
    }
}

extension MarketItemListViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 120)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
}
