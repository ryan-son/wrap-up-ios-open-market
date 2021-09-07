//
//  MarketItemListViewController.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/08/24.
//

import UIKit

final class MarketItemListViewController: UIViewController {

    private enum CellStyle {
        case list
        case grid
    }

    // MARK: Properties

    private let viewModel = MarketItemListViewModel()
    private var cellStyle: CellStyle = .list

    // MARK: Views

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(MarketItemListCollectionViewCell.self,
                                forCellWithReuseIdentifier: MarketItemListCollectionViewCell.reuseIdentifier)
        collectionView.register(MarketItemGridCollectionViewCell.self,
                                forCellWithReuseIdentifier: MarketItemGridCollectionViewCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.accessibilityIdentifier = Style.collectionViewAccessibilityIdentifier
        return collectionView
    }()

    private let addNewPostButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(addNewPostButtonTapped), for: .touchUpInside)
        button.setBackgroundImage(Style.AddNewPostButton.image, for: .normal)
        button.tintColor = SharedStyle.tintColor
        button.backgroundColor = Style.AddNewPostButton.backgroundColor
        button.layer.cornerRadius = Style.AddNewPostButton.cornerRadius
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.adjustsImageSizeForAccessibilityContentSizeCategory = true
        button.accessibilityIdentifier = Style.AddNewPostButton.accessibilityIdentifier
        return button
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.startAnimating()
        activityIndicator.accessibilityIdentifier = Style.activityIndicatorAccessibilityIdentifier
        return activityIndicator
    }()

    // MARK: View Lifecycle

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

    // MARK: Data binding

    private func bindWithViewModel() {
        viewModel.bind { [weak self] state in
            switch state {
            case .fetched(let indexPaths):
                self?.collectionView.insertItems(at: indexPaths)
                self?.activityIndicator.stopAnimating()
            case .refreshed:
                self?.collectionView.reloadData()
                self?.collectionView.refreshControl?.endRefreshing()
                self?.activityIndicator.stopAnimating()
            default:
                break
            }
        }
    }

    // MARK: Set attributes of the view controller

    private func setupAttributes() {
        view.backgroundColor = .systemBackground
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        title = Style.navigationBarTitle
        let changeCellStyleBarButton = UIBarButtonItem(image: Style.ChangeCellStyleBarButton.gridCellButtonImage,
                                                       style: .plain, target: self,
                                                       action: #selector(changeCellStyleButtonTapped))
        changeCellStyleBarButton.accessibilityIdentifier = Style.ChangeCellStyleBarButton.accessibilityIdentifier

        let refreshBarButton = UIBarButtonItem(barButtonSystemItem: .refresh,
                                               target: self,
                                               action: #selector(refreshMarketItems))
        refreshBarButton.accessibilityIdentifier = Style.refreshMarketItemsBarButtonAccessibilityIdentifier

        let rightBarButtonItems = [refreshBarButton, changeCellStyleBarButton]
        rightBarButtonItems.forEach { $0.tintColor = Style.navigationBarButtonItemTintColor }
        navigationItem.setRightBarButtonItems(rightBarButtonItems, animated: true)
    }

    private func setupViews() {
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        collectionView.addSubview(addNewPostButton)

        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(refreshMarketItems), for: .valueChanged)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            addNewPostButton.widthAnchor.constraint(equalToConstant: Style.AddNewPostButton.size),
            addNewPostButton.heightAnchor.constraint(equalToConstant: Style.AddNewPostButton.size),
            addNewPostButton.trailingAnchor.constraint(equalTo: collectionView.frameLayoutGuide.trailingAnchor,
                                                       constant: Style.AddNewPostButton.trailingConstant),
            addNewPostButton.bottomAnchor.constraint(equalTo: collectionView.frameLayoutGuide.bottomAnchor,
                                                     constant: Style.AddNewPostButton.bottomConstant)
        ])
    }

    private func setupDelegates() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
    }

    // MARK: Actions

    @objc private func addNewPostButtonTapped() {
        let registerViewModel = MarketItemRegisterViewModel()
        let registerViewController = MarketItemRegisterViewController(intent: .register)
        registerViewController.bind(with: registerViewModel)
		registerViewController.delegate = self
        navigationController?.pushViewController(registerViewController, animated: true)
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
            navigationItem.rightBarButtonItems?.last?.image = Style.ChangeCellStyleBarButton.gridCellButtonImage
        case .grid:
            navigationItem.rightBarButtonItems?.last?.image = Style.ChangeCellStyleBarButton.listCellButtonImage
        }
    }

    @objc private func refreshMarketItems() {
        collectionView.refreshControl?.beginRefreshing()
        activityIndicator.startAnimating()
        viewModel.refresh()
    }
}

// MARK: - UICollectionViewDataSource

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

// MARK: - UICollectionViewDelegateFlowLayout

extension MarketItemListViewController: UICollectionViewDelegateFlowLayout {

    private func cellSize(viewWidth: CGFloat, viewHeight: CGFloat) -> CGSize {
        let itemsPerRow: CGFloat = UIWindow.isLandscape
            ? Style.landscapeGridItemsPerRow
            : Style.portraitGridItemsPerRow
        let widthPadding = Style.gridSectionInset.left * (itemsPerRow + 1)
        let itemsPerColumn: CGFloat = UIWindow.isLandscape
            ? Style.landscapeGridItemsPerColumn
            : Style.portraitGridItemsPerColumn
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let marketItem = viewModel.marketItems[indexPath.item]
        let marketItemDetailViewModel = MarketItemDetailViewModel(marketItemID: marketItem.id)
        let marketItemDetailViewController = MarketItemDetailViewController()
		marketItemDetailViewController.delegate = self

        marketItemDetailViewController.bind(with: marketItemDetailViewModel)
        marketItemDetailViewModel.fire()
        navigationController?.pushViewController(marketItemDetailViewController, animated: true)
    }
}

// MARK: - MarketItemRegisterViewControllerDelegate

extension MarketItemListViewController: MarketItemRegisterViewControllerDelegate {

	func didEndEditing(with marketItem: MarketItem) {
		let marketItemDetailViewModel = MarketItemDetailViewModel(marketItemID: marketItem.id)
		let marketItemDetailViewController = MarketItemDetailViewController()
		marketItemDetailViewController.delegate = self
		marketItemDetailViewController.bind(with: marketItemDetailViewModel)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.navigationController?.pushViewController(marketItemDetailViewController, animated: true)
            marketItemDetailViewModel.fire()
        }
	}
}

// MARK: - UICollectionViewDataSourcePrefetching

extension MarketItemListViewController: UICollectionViewDataSourcePrefetching {

    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            DispatchQueue.global(qos: .utility).async {
                let marketItem = self.viewModel.marketItems[indexPath.item]
                let marketItemCellViewModel = MarketItemCellViewModel(marketItem: marketItem)
                marketItemCellViewModel.prefetchThumbnail()
            }
        }
    }
}

// MARK: - MarketItemDetailViewControllerDelegate

extension MarketItemListViewController: MarketItemDetailViewControllerDelegate {

	func didChangeMarketItem() {
		refreshMarketItems()
	}
}

// MARK: - Namespaces

extension MarketItemListViewController {

	private enum Style {

		static let navigationBarTitle: String = "Ryan Market"
		static let listCellHeight: CGFloat = 160
		static let portraitGridItemsPerRow: CGFloat = 2
		static let portraitGridItemsPerColumn: CGFloat = 2.7
		static let landscapeGridItemsPerRow: CGFloat = 4
		static let landscapeGridItemsPerColumn: CGFloat = 1.2
		static let numberOfLastItemsToTriggerFetch: Int = 10
		static let gridSectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
		static let gridSectionMinimumLineSpacing: CGFloat = 20
		static let navigationBarButtonItemTintColor: UIColor = .label
        static let collectionViewAccessibilityIdentifier: String = "marketItemList"
        static let activityIndicatorAccessibilityIdentifier: String = "loadingSpinner"
        static let refreshMarketItemsBarButtonAccessibilityIdentifier: String = "refreshMarketItems"

		enum ChangeCellStyleBarButton {
			static let listCellButtonImage = UIImage(systemName: "list.dash")
			static let gridCellButtonImage = UIImage(systemName: "square.grid.2x2")
            static let accessibilityIdentifier: String = "changeCellStyle"
		}

		enum AddNewPostButton {
			static let size: CGFloat = 80
			static let cornerRadius: CGFloat = size / 2
			static let image = UIImage(systemName: "plus.circle.fill")
			static let backgroundColor: UIColor = .systemBackground
			static let trailingConstant: CGFloat = -30
			static let bottomConstant: CGFloat = -70
            static let accessibilityIdentifier: String = "addNewPost"
		}
	}
}

extension UIWindow {

    static var isLandscape: Bool {
        return UIApplication.shared.windows
            .first?
            .windowScene?
            .interfaceOrientation
            .isLandscape ?? false
    }
}
