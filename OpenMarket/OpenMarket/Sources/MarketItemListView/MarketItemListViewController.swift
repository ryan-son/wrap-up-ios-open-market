//
//  MarketItemListViewController.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/08/24.
//

import UIKit

final class MarketItemListViewController: UIViewController {

    private enum Style {

        static let listCellHeight: CGFloat = 120
        static let numberOfLastItemsToTriggerFetch: Int = 3

        enum ChangeCellStyleBarButton {
            static let listCellButtonImage = UIImage(systemName: "list.dash")
            static let gridCellButtonImage = UIImage(systemName: "square.grid.2x2")
        }
    }

    private enum CellStyle {
        case list
        case grid
    }

    private let viewModel = MarketItemListViewModel()
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(MarketItemListCollectionViewCell.self,
                                forCellWithReuseIdentifier: MarketItemListCollectionViewCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    private var cellStyle: CellStyle = .list

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAttributes()
        setupNavigationBar()
        setupViews()
        setupConstraints()
        setupDelegates()
        bindWithViewModel()
        viewModel.list()
    }

    private func setupAttributes() {
        view.backgroundColor = .systemBackground
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Open Market"
        let changeCellStyleBarButton = UIBarButtonItem(image: UIImage(systemName: "list.dash"),
                                                       style: .plain, target: self,
                                                       action: #selector(changeCellStyleButtonTapped))
        navigationItem.rightBarButtonItems = [changeCellStyleBarButton]
    }

    private func setupViews() {
        view.addSubview(collectionView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupDelegates() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    private func bindWithViewModel() {
        viewModel.bind { [weak self] state in
            switch state {
            case .fetched(let indexPaths):
                DispatchQueue.main.async {
                    self?.collectionView.insertItems(at: indexPaths)
                }
            default:
                break
            }
        }
    }

    @objc private func changeCellStyleButtonTapped() {
        toggleCellStyle()
        changeCellStyleButtonImage()
    }

    private func toggleCellStyle() {
        cellStyle = cellStyle == .list ? .grid : .list
    }

    private func changeCellStyleButtonImage() {
        switch cellStyle {
        case .list:
            navigationItem.rightBarButtonItems?.first?.image = Style.ChangeCellStyleBarButton.listCellButtonImage
        case .grid:
            navigationItem.rightBarButtonItems?.first?.image = Style.ChangeCellStyleBarButton.gridCellButtonImage
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
        return CGSize(width: collectionView.bounds.width, height: Style.listCellHeight)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if viewModel.marketItems.count == indexPath.item + Style.numberOfLastItemsToTriggerFetch {
            viewModel.list()
        }
    }
}
