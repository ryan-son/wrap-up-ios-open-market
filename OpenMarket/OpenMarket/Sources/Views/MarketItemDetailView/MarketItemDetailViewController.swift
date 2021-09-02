//
//  MarketItemDetailViewController.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/08/28.
//

import UIKit

protocol MarketItemDetailViewControllerDelegate: AnyObject {

	func didChangeMarketItem()
}

final class MarketItemDetailViewController: UIViewController {

    // MARK: Properties

    private var viewModel: MarketItemDetailViewModel?
	weak var delegate: MarketItemDetailViewControllerDelegate?
    private var isUpdated: Bool = false

    // MARK: Views

    private let contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let imageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private var imageViews: [UIImageView] = []

    private let imageScrollViewPageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = Style.ImageScrollViewPageControl.currentPageIndicatorTintColor
        pageControl.pageIndicatorTintColor = Style.ImageScrollViewPageControl.pageIndicatorTintColor
        pageControl.hidesForSinglePage = true
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()

    private let textContentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = Style.spacing / 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let textContentUpperStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .firstBaseline
        stackView.distribution = .fill
        return stackView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: Style.TitleLabel.font)
        label.textColor = Style.TitleLabel.textColor
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = .zero
        return label
    }()

    private let stockLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: Style.StockLabel.font)
        label.textColor = Style.StockLabel.textColor
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    private let textContentLowerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        return stackView
    }()

    private let discountedPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: Style.DiscountedPriceLabel.font)
        label.textColor = Style.DiscountedPriceLabel.textColor
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: Style.PriceLabel.font)
        label.textColor = Style.PriceLabel.textColor
        return label
    }()

    private let bodyTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: Style.BodyTextLabel.font)
        label.textColor = Style.BodyTextLabel.textColor
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = .zero
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        return activityIndicator
    }()

    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setAttributes()
		setupNavigationBar()
        setupViews()
        setupConstraints()
        setupDelegates()
    }

    // MARK: Data binding

    func bind(with viewModel: MarketItemDetailViewModel) {
        self.viewModel = viewModel

        viewModel.bind { [weak self] state in
            switch state {
            case .fetch(let metaData):
                self?.setPageControlNumberOfPages(to: metaData.numberOfImages)
                self?.titleLabel.text = metaData.title
                self?.stockLabel.text = metaData.stock
                self?.discountedPriceLabel.attributedText = metaData.discountedPrice
                self?.priceLabel.text = metaData.price
                self?.bodyTextLabel.text = metaData.descriptions
            case .fetchImage(let image, let index):
                self?.addImageViewToImageScrollView(image, at: index)
            case .verify(let marketItem, let password):
                self?.pushToEditViewController(with: marketItem, password: password)
            case .failedToStartEdit:
                self?.presentFailedToStartEditAlert()
            case .delete:
                self?.presentSuccessfullyDeletedAlert()
            case .deleteFailed:
                self?.presentFailedToDeleteAlert()
            case .error(let error):
                print(error)
            case .update:
                break
            default:
                break
            }
        }
    }

    // MARK: Set attributes of the view controller

    private func setAttributes() {
        view.backgroundColor = Style.backgroundColor
    }

	private func setupNavigationBar() {
		title = Style.navigationTitle

        navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(title: "< Back", style: .plain, target: self, action: #selector(backButtonDidTapped))
        navigationItem.setLeftBarButton(backButton, animated: false)

		let moreActionsButton = UIBarButtonItem(image: Style.moreActionButtonImage, style: .plain, target: self, action: #selector(moreActionsButtonTapped))
		navigationItem.setRightBarButton(moreActionsButton, animated: false)
	}

	@objc private func moreActionsButtonTapped() {
		let actionSheet = UIAlertController(title: "무엇을 해볼까요?", message: nil, preferredStyle: .actionSheet)
		let editAction = UIAlertAction(title: "상품 수정", style: .default) { _ in
            self.showEditPasswordInputAlert()
		}
		let deleteAction = UIAlertAction(title: "상품 삭제", style: .destructive) { _ in
			self.showDeletePasswordInputAlert()
		}
		let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        actionSheet.addAction(editAction)
		actionSheet.addAction(deleteAction)
		actionSheet.addAction(cancelAction)
		present(actionSheet, animated: true)
	}

    private func setupViews() {
        imageScrollView.addSubview(imageScrollViewPageControl)

        textContentUpperStackView.addArrangedSubview(titleLabel)
        textContentUpperStackView.addArrangedSubview(stockLabel)

        textContentLowerStackView.addArrangedSubview(discountedPriceLabel)
        textContentLowerStackView.addArrangedSubview(priceLabel)

        textContentStackView.addArrangedSubview(textContentUpperStackView)
        textContentStackView.addArrangedSubview(textContentLowerStackView)

        contentScrollView.addSubview(imageScrollView)
        contentScrollView.addSubview(textContentStackView)
        contentScrollView.addSubview(bodyTextLabel)

        view.addSubview(contentScrollView)
        view.addSubview(activityIndicator)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentScrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: view.widthAnchor),
            contentScrollView.contentLayoutGuide.topAnchor.constraint(equalTo: imageScrollView.topAnchor),
            contentScrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: bodyTextLabel.bottomAnchor,
                                                                         constant: Style.spacing),

            imageScrollView.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor),
            imageScrollView.trailingAnchor.constraint(equalTo: contentScrollView.trailingAnchor),
            imageScrollView.topAnchor.constraint(equalTo: contentScrollView.topAnchor),
            imageScrollView.heightAnchor.constraint(equalTo: contentScrollView.widthAnchor),

            imageScrollViewPageControl.centerXAnchor.constraint(equalTo: imageScrollView.frameLayoutGuide.centerXAnchor),
            imageScrollViewPageControl.bottomAnchor.constraint(equalTo: imageScrollView.frameLayoutGuide.bottomAnchor,
                                                               constant: -Style.spacing),

            textContentStackView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            textContentStackView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            textContentStackView.topAnchor.constraint(equalTo: imageScrollView.bottomAnchor, constant: Style.spacing),

            bodyTextLabel.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            bodyTextLabel.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            bodyTextLabel.topAnchor.constraint(equalTo: textContentStackView.bottomAnchor, constant: Style.spacing)
        ])
    }

    private func setupDelegates() {
        imageScrollView.delegate = self
    }

    // MARK: Event handlers upon data binding

    private func setPageControlNumberOfPages(to number: Int) {
        imageScrollViewPageControl.numberOfPages = number
    }

    private func addImageViewToImageScrollView(_ image: UIImage, at index: Int) {
        let imageView = UIImageView()
        let xPosition: CGFloat = view.frame.width * CGFloat(index)
        imageView.frame = CGRect(x: xPosition, y: .zero, width: imageScrollView.bounds.width, height: imageScrollView.bounds.height)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = .zero
        imageScrollView.insertSubview(imageView, belowSubview: imageScrollViewPageControl)
        imageScrollView.contentSize.width = imageView.frame.width * CGFloat(index + 1)
        imageViews.append(imageView)

        UIView.animate(withDuration: 0.6) {
            imageView.alpha = 1
        }
    }

    private func setPageControlPage(to selectedPage: Int) {
        imageScrollViewPageControl.currentPage = selectedPage
    }

    private func showEditPasswordInputAlert() {
        let passwordInputAlert = UIAlertController(title: "비밀번호를 입력해주세요.", message: nil, preferredStyle: .alert)
        passwordInputAlert.addTextField { textField in
            textField.placeholder = "비밀번호"
            textField.textAlignment = .center
        }
        let okAction = UIAlertAction(title: "확인", style: .destructive) { _ in
            guard let password = passwordInputAlert.textFields?.first?.text else { return }
            self.viewModel?.verifyPassword(password)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        passwordInputAlert.addAction(okAction)
        passwordInputAlert.addAction(cancelAction)
        present(passwordInputAlert, animated: true)
    }

    private func presentFailedToStartEditAlert() {
        let alert = UIAlertController(title: "비밀번호가 다릅니다.", message: nil, preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "재시도", style: .default) { _ in
            self.showEditPasswordInputAlert()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(retryAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }

    private func pushToEditViewController(with marketItem: MarketItem, password: String) {
        guard let marketItem = viewModel?.marketItem else { return }
        let marketItemRegisterViewModel = MarketItemRegisterViewModel(marketItem: marketItem)
        let marketItemRegisterViewController = MarketItemRegisterViewController(intent: .edit)
        marketItemRegisterViewController.delegate = self
        marketItemRegisterViewController.bind(with: marketItemRegisterViewModel)
        viewModel?.images.forEach { marketItemRegisterViewModel.appendImage($0) }
        marketItemRegisterViewModel.startEditing(with: password)
        navigationController?.pushViewController(marketItemRegisterViewController, animated: true)
    }

	private func showDeletePasswordInputAlert() {
		let passwordInputAlert = UIAlertController(title: "비밀번호를 입력해주세요.", message: nil, preferredStyle: .alert)
		passwordInputAlert.addTextField { textField in
			textField.placeholder = "비밀번호"
			textField.textAlignment = .center
		}
		let okAction = UIAlertAction(title: "확인", style: .destructive) { _ in
			guard let text = passwordInputAlert.textFields?.first?.text else { return }
			self.viewModel?.deleteMarketItem(with: text)
		}
		let cancelAction = UIAlertAction(title: "취소", style: .cancel)
		passwordInputAlert.addAction(okAction)
		passwordInputAlert.addAction(cancelAction)
		present(passwordInputAlert, animated: true)
	}

	private func presentSuccessfullyDeletedAlert() {
		let alert = UIAlertController(title: "삭제되었습니다.", message: nil, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "확인", style: .default) { _ in
			self.navigationController?.popViewController(animated: true)
			self.delegate?.didChangeMarketItem()
		}
		alert.addAction(okAction)
		present(alert, animated: true)
	}

	private func presentFailedToDeleteAlert() {
		let alert = UIAlertController(title: "비밀번호가 다릅니다.", message: nil, preferredStyle: .alert)
		let retryAction = UIAlertAction(title: "재시도", style: .default) { _ in
			self.showDeletePasswordInputAlert()
		}
		let cancelAction = UIAlertAction(title: "취소", style: .cancel)
		alert.addAction(retryAction)
		alert.addAction(cancelAction)
		present(alert, animated: true)
	}

    @objc private func backButtonDidTapped() {
        if isUpdated {
            delegate?.didChangeMarketItem()
        }
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UIScrollViewDelegate

extension MarketItemDetailViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.x / scrollView.frame.size.width
        let destinationPage = Int(round(position))
        setPageControlPage(to: destinationPage)
    }
}

extension MarketItemDetailViewController: MarketItemRegisterViewControllerDelegate {

    func didEndEditing(with marketItem: MarketItem) {
        activityIndicator.startAnimating()
        isUpdated = true
        imageScrollView.subviews.forEach {
            if let imageView = $0 as? UIImageView {
                imageView.removeFromSuperview()
            }
        }
        imageViews.removeAll()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.viewModel?.refresh()
            self.activityIndicator.stopAnimating()
        }
    }
}

// MARK: - Namespaces

extension MarketItemDetailViewController {

	private enum Style {

		static let navigationTitle: String = "Item Detail"
		static let moreActionButtonImage = UIImage(systemName: "ellipsis")
		static let backgroundColor: UIColor = .systemBackground
		static let spacing: CGFloat = 20

		enum ImageScrollViewPageControl {
			static let currentPageIndicatorTintColor: UIColor = .systemOrange
			static let pageIndicatorTintColor: UIColor = .systemGray.withAlphaComponent(0.8)
		}

		enum TitleLabel {
			static let font: UIFont.TextStyle = .title1
			static let textColor: UIColor = .label
		}

		enum StockLabel {
			static let font: UIFont.TextStyle = .body
			static let textColor: UIColor = .secondaryLabel
		}

		enum DiscountedPriceLabel {
			static let font: UIFont.TextStyle = .callout
			static let textColor: UIColor = .secondaryLabel
		}

		enum PriceLabel {
			static let font: UIFont.TextStyle = .headline
			static let textColor: UIColor = .label
		}

		enum BodyTextLabel {
			static let font: UIFont.TextStyle = .title3
			static let textColor: UIColor = .label
		}
	}
}
