//
//  MarketItemListCollectionViewCell.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/08/25.
//

import UIKit

final class MarketItemListCollectionViewCell: UICollectionViewCell {

    private enum Style {

        enum ThumbnailImageView {
            static let cornerRadius: CGFloat = 10
        }

        enum TextContentStackView {
            static let spacing: CGFloat = 8
        }

        enum UpperStackView {
            static let spacing: CGFloat = 8
        }

        enum TitleLabel {
            static let font: UIFont.TextStyle = .title3
            static let textColor: UIColor = .label
        }

        enum StockLabel {
            static let font: UIFont.TextStyle = .callout
            static let textColor: UIColor = .secondaryLabel
            static let outOfStockTextColor: UIColor = .systemOrange
        }

        enum LowerStackView {
            static let spacing: CGFloat = .zero
        }

        enum DiscountedPriceLabel {
            static let font: UIFont.TextStyle = .body
            static let textColor: UIColor = .tertiaryLabel
        }

        enum PriceLabel {
            static let font: UIFont.TextStyle = .headline
            static let textColor: UIColor = .label
        }

        enum SeparatorView {
            static let backgroundColor: UIColor = .separator
            static let height: CGFloat = 0.5
        }

        enum Constraint {
            static let thumbnailSizeAgainstContentView: CGFloat = 0.7
            static let contentViewPadding: CGFloat = 20
        }
    }

    static let reuseIdentifier = "MarketItemListCollectionViewCell"
    private var viewModel: MarketItemCellViewModel?

    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = Style.ThumbnailImageView.cornerRadius
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let textContentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = Style.TextContentStackView.spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let upperStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = Style.UpperStackView.spacing
        return stackView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: Style.TitleLabel.font)
        return label
    }()

    private let stockLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: Style.StockLabel.font)
        label.textColor = Style.StockLabel.textColor
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()

    private let lowerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = Style.LowerStackView.spacing
        return stackView
    }()

    private let discountedPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: Style.DiscountedPriceLabel.font)
        label.textColor = Style.DiscountedPriceLabel.textColor
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: Style.PriceLabel.font)
        label.textColor = Style.PriceLabel.textColor
        return label
    }()

    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = Style.SeparatorView.backgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupConstraints()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }

    private func setupViews() {
        upperStackView.addArrangedSubview(titleLabel)
        upperStackView.addArrangedSubview(stockLabel)

        lowerStackView.addArrangedSubview(discountedPriceLabel)
        lowerStackView.addArrangedSubview(priceLabel)

        textContentStackView.addArrangedSubview(upperStackView)
        textContentStackView.addArrangedSubview(lowerStackView)

        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(textContentStackView)
        contentView.addSubview(separatorView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                        constant: Style.Constraint.contentViewPadding),
            thumbnailImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            thumbnailImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor,
                                                       multiplier: Style.Constraint.thumbnailSizeAgainstContentView),
            thumbnailImageView.widthAnchor.constraint(equalTo: thumbnailImageView.heightAnchor),
            textContentStackView.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor,
                                                          constant: Style.Constraint.contentViewPadding),
            textContentStackView.topAnchor.constraint(equalTo: thumbnailImageView.topAnchor),
            textContentStackView.bottomAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor),
            textContentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                           constant: -Style.Constraint.contentViewPadding)
        ])

        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                   constant: Style.Constraint.contentViewPadding),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                    constant: -Style.Constraint.contentViewPadding),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: Style.SeparatorView.height)
        ])
    }

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

    private func reset() {
        viewModel?.cancelThumbnailRequest()
        thumbnailImageView.image = nil
        titleLabel.text = nil
        stockLabel.text = nil
        discountedPriceLabel.attributedText = nil
        priceLabel.text = nil
    }
}
