//
//  MarketItemListViewController.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/08/24.
//

import UIKit

final class MarketItemListViewController: UIViewController {

    private enum Style {

        static let listCellHeight: CGFloat = 160
        static let portraitGridItemsPerRow: CGFloat = 2
        static let portraitGridItemsPerColumn: CGFloat = 2.7
        static let landscapeGridItemsPerRow: CGFloat = 4
        static let landscapeGridItemsPerColumn: CGFloat = 1.2
        static let numberOfLastItemsToTriggerFetch: Int = 10
        static let gridSectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        static let gridSectionMinimumLineSpacing: CGFloat = 20

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
        collectionView.register(MarketItemGridCollectionViewCell.self,
                                forCellWithReuseIdentifier: MarketItemGridCollectionViewCell.reuseIdentifier)
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
        let changeCellStyleBarButton = UIBarButtonItem(image: Style.ChangeCellStyleBarButton.gridCellButtonImage,
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

        guard let indexPathForFirstVisibleCell = collectionView.indexPathsForVisibleItems.sorted().first else { return }
        collectionView.reloadData()
        collectionView.scrollToItem(at: indexPathForFirstVisibleCell, at: .bottom, animated: false)
    }

    private func toggleCellStyle() {
        cellStyle = cellStyle == .list ? .grid : .list
    }

    private func changeCellStyleButtonImage() {
        switch cellStyle {
        case .list:
            navigationItem.rightBarButtonItems?.first?.image = Style.ChangeCellStyleBarButton.gridCellButtonImage
        case .grid:
            navigationItem.rightBarButtonItems?.first?.image = Style.ChangeCellStyleBarButton.listCellButtonImage
        }
    }
}

extension MarketItemListViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.marketItems.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: MarketItemRepresentable

        switch cellStyle {
        case .list:
            guard let listCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MarketItemListCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as? MarketItemListCollectionViewCell else { return MarketItemListCollectionViewCell() }

            cell = listCell
        case .grid:
            guard let gridCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MarketItemGridCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as? MarketItemGridCollectionViewCell else { return MarketItemGridCollectionViewCell() }

            cell = gridCell
        }

        let marketItem = viewModel.marketItems[indexPath.item]
        let marketItemCellViewModel = MarketItemCellViewModel(marketItem: marketItem)

        cell.bind(with: marketItemCellViewModel)
        cell.fire()

        return cell
    }
}

extension MarketItemListViewController: UICollectionViewDelegateFlowLayout {

    private func cellSize(viewWidth: CGFloat, viewHeight: CGFloat) -> CGSize {
        let itemsPerRow: CGFloat = traitCollection.horizontalSizeClass == .compact
            ? Style.portraitGridItemsPerRow
            : Style.landscapeGridItemsPerRow
        let widthPadding = Style.gridSectionInset.left * (itemsPerRow + 1)
        let itemsPerColumn: CGFloat = traitCollection.horizontalSizeClass == .compact
            ? Style.portraitGridItemsPerColumn
            : Style.landscapeGridItemsPerColumn
        let heightPadding = Style.gridSectionInset.top * (itemsPerColumn + 1)

        let cellWidth = (viewWidth - widthPadding) / itemsPerRow
        let cellHeight = (viewHeight - heightPadding) / itemsPerColumn
        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch cellStyle {
        case .list:
            return CGSize(width: collectionView.bounds.width, height: Style.listCellHeight)
        case .grid:
            return cellSize(viewWidth: collectionView.bounds.width, viewHeight: collectionView.bounds.height)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch cellStyle {
        case .list:
            return .zero
        default:
            return Style.gridSectionMinimumLineSpacing
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        switch cellStyle {
        case .list:
            return .zero
        default:
            return Style.gridSectionInset
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if viewModel.marketItems.count <= indexPath.item + Style.numberOfLastItemsToTriggerFetch {
            viewModel.list()
        }
    }
}
