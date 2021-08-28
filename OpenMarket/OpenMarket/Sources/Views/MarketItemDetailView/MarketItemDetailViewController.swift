//
//  MarketItemDetailViewController.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/08/28.
//

import UIKit

final class MarketItemDetailViewController: UIViewController {

    private enum Style {

        static let navigationTitle: String = "Item Detail"
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

    private var viewModel: MarketItemDetailViewModel?

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

    override func viewDidLoad() {
        super.viewDidLoad()
        setAttributes()
        setupViews()
        setupConstraints()
        setupDelegates()
        viewModel?.fire()
    }

    private func setAttributes() {
        title = Style.navigationTitle
        view.backgroundColor = Style.backgroundColor
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
            case .error(let error):
                print(error)
                break
            case .update:
                break
            default:
                break
            }
        }
    }

    private func setPageControlNumberOfPages(to number: Int) {
        imageScrollViewPageControl.numberOfPages = number
    }

    private func addImageViewToImageScrollView(_ image: UIImage, at index: Int) {
        let imageView = UIImageView()
        let xPosition: CGFloat = view.frame.width * CGFloat(index)
        imageView.frame = CGRect(x: xPosition, y: .zero, width: imageScrollView.bounds.width, height: imageScrollView.bounds.height)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageScrollView.insertSubview(imageView, belowSubview: imageScrollViewPageControl)
        imageScrollView.contentSize.width = imageView.frame.width * CGFloat(index + 1)
        imageViews.append(imageView)
    }

    private func setPageControlPage(to selectedPage: Int) {
        imageScrollViewPageControl.currentPage = selectedPage
    }
}

extension MarketItemDetailViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.x / scrollView.frame.size.width
        let destinationPage = Int(round(position))
        setPageControlPage(to: destinationPage)
    }
}
