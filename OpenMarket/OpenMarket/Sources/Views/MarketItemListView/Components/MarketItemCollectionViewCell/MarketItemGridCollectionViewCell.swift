//
//  MarketItemGridCollectionViewCell.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/08/25.
//

import UIKit

final class MarketItemGridCollectionViewCell: UICollectionViewCell {

	// MARK: Properties

    static let reuseIdentifier = "MarketItemGridCollectionViewCell"
    private var viewModel: MarketItemCellViewModel?

	// MARK: Views

    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = Style.ThumbnailImageView.cornerRadius
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.accessibilityIdentifier = Style.ThumbnailImageView.accessibilityIdentifier
        return imageView
    }()

    private let textContentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = Style.TextContentStackView.spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: Style.TitleLabel.font)
        label.textColor = Style.TitleLabel.textColor
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.numberOfLines = Style.TitleLabel.numberOfLines
        label.accessibilityIdentifier = Style.TitleLabel.accessibilityIdentifier
        return label
    }()

    private let stockLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: Style.StockLabel.font)
        label.textColor = Style.StockLabel.textColor
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.accessibilityIdentifier = Style.StockLabel.accessibilityIdentifier
        return label
    }()

    private let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = Style.PriceStackView.spacing
        return stackView
    }()

    private let discountedPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: Style.DiscountedPriceLabel.font)
        label.textColor = Style.DiscountedPriceLabel.textColor
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.accessibilityIdentifier = Style.DiscountedPriceLabel.accessibilityIdentifier
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: Style.PriceLabel.font)
        label.textColor = Style.PriceLabel.textColor
        label.accessibilityIdentifier = Style.PriceLabel.accessibilityIdentifier
        return label
    }()

	// MARK: Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAttributes()
        setupViews()
        setupConstraints()
    }

	@available(iOS, unavailable, message: "Use init(frame:) instead")
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupAttributes()
        setupViews()
        setupConstraints()
    }

	// MARK: Set up views

    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }

	private func reset() {
		viewModel?.cancelThumbnailRequest()
		thumbnailImageView.image = nil
		titleLabel.text = nil
		stockLabel.text = nil
		discountedPriceLabel.attributedText = nil
		priceLabel.text = nil
	}

    private func setupAttributes() {
        layer.borderWidth = Style.borderWidth
        layer.cornerRadius = Style.cornerRadius
        accessibilityIdentifier = Style.cellAccessibilityIdentifier
    }

    private func setupViews() {
        priceStackView.addArrangedSubview(discountedPriceLabel)
        priceStackView.addArrangedSubview(priceLabel)

        textContentStackView.addArrangedSubview(titleLabel)
        textContentStackView.addArrangedSubview(priceStackView)
        textContentStackView.addArrangedSubview(stockLabel)

        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(textContentStackView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                    constant: Style.Constraint.contentViewPadding),
            thumbnailImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor,
                                                       multiplier: Style.Constraint.thumbnailSizeAgainstContentView),
            thumbnailImageView.widthAnchor.constraint(equalTo: thumbnailImageView.heightAnchor),
            thumbnailImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            textContentStackView.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor,
                                                      constant: Style.Constraint.contentViewPadding),
            textContentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                          constant: Style.Constraint.contentViewPadding),
            textContentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                           constant: -Style.Constraint.contentViewPadding),
            textContentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                         constant: -Style.Constraint.contentViewPadding)
        ])
    }
}

extension MarketItemGridCollectionViewCell: MarketItemRepresentable {

	// MARK: Data binding

	func bind(with viewModel: MarketItemCellViewModel) {
		self.viewModel = viewModel

		viewModel.bind { [weak self] state in
			switch state {
			case .update(let metaData):
				self?.thumbnailImageView.image = metaData.thumbnail
				self?.titleLabel.text = metaData.title
				self?.stockLabel.text = metaData.stock
				self?.discountedPriceLabel.isHidden = !metaData.hasDiscountedPrice
				self?.discountedPriceLabel.attributedText = metaData.discountedPrice
				self?.priceLabel.text = metaData.price

				self?.stockLabel.textColor = metaData.isOutOfStock ?
					Style.StockLabel.outOfStockTextColor
					: Style.StockLabel.textColor
			case .error(_):
				self?.thumbnailImageView.image = nil
			default:
				break
			}
		}
	}

	func fire() {
		viewModel?.fire()
	}
}

// MARK: - Namespaces

extension MarketItemGridCollectionViewCell {

	private enum Style {

		static let borderWidth: CGFloat = 0.5
		static let cornerRadius: CGFloat = 10
        static let cellAccessibilityIdentifier: String = "marketItem"

		enum ThumbnailImageView {
			static let cornerRadius: CGFloat = 10
            static let accessibilityIdentifier: String = "Thumbnail"
		}

		enum TextContentStackView {
			static let spacing: CGFloat = 8
		}

		enum TitleLabel {
			static let font: UIFont.TextStyle = .title3
			static let textColor: UIColor = .label
			static let numberOfLines: Int = 2
            static let accessibilityIdentifier: String = "marketItemTitle"
		}

		enum StockLabel {
			static let font: UIFont.TextStyle = .callout
			static let textColor: UIColor = .secondaryLabel
			static let outOfStockTextColor: UIColor = .systemOrange
            static let accessibilityIdentifier: String = "stock"
		}

		enum PriceStackView {
			static let spacing: CGFloat = .zero
		}

		enum DiscountedPriceLabel {
			static let font: UIFont.TextStyle = .body
			static let textColor: UIColor = .tertiaryLabel
            static let accessibilityIdentifier: String = "discountedPrice"
		}

		enum PriceLabel {
			static let font: UIFont.TextStyle = .headline
			static let textColor: UIColor = .label
            static let accessibilityIdentifier: String = "price"
		}

		enum Constraint {
			static let thumbnailSizeAgainstContentView: CGFloat = 0.4
			static let contentViewPadding: CGFloat = 20
		}
	}
}
