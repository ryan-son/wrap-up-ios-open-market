//
//  AddPhotoCollectionViewCell.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/09/01.
//

import UIKit

final class AddPhotoCollectionViewCell: UICollectionViewCell {

	// MARK: Type properties

    static let reuseIdentifier: String = "AddPhotoCollectionViewCell"

	// MARK: Views

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.spacing = Style.ContentStackView.spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let cameraIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Style.CameraIconImageView.image
        imageView.tintColor = Style.CameraIconImageView.tintColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let imageCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: Style.ImageCountLabel.font)
        label.textColor = Style.ImageCountLabel.textColor
        label.text = Style.ImageCountLabel.initialText
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()

	// MARK: Initializers

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setStyle()
        setupViews()
        setupConstraints()
    }

    @available(iOS, unavailable, message: "Use init(frame:) instead")
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

	// MARK: Set up styles and views

    private func setStyle() {
        contentView.layer.borderColor = Style.borderColor
        contentView.layer.borderWidth = Style.borderWidth
        contentView.layer.cornerRadius = Style.cornerRadius
        contentView.isUserInteractionEnabled = true
        accessibilityIdentifier = "addPhoto"
    }

    private func setupViews() {
        contentStackView.addArrangedSubview(cameraIconImageView)
        contentStackView.addArrangedSubview(imageCountLabel)
        contentView.addSubview(contentStackView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentStackView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor,
                                                  constant: Style.minimumContentInset),
            contentStackView.bottomAnchor.constraint(greaterThanOrEqualTo: contentView.bottomAnchor,
                                                     constant: -Style.minimumContentInset),
            contentStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cameraIconImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor,
                                                       multiplier: Style.CameraIconImageView.widthAgainstButton),
            cameraIconImageView.heightAnchor.constraint(equalTo: cameraIconImageView.widthAnchor,
                                                        multiplier: Style.CameraIconImageView.heightAgainstOwnWidth)
        ])
    }
}

// MARK: - Namespaces

extension AddPhotoCollectionViewCell {

	private enum Style {

		static let borderColor: CGColor = UIColor.secondaryLabel.cgColor
		static let borderWidth: CGFloat = 0.5
		static let cornerRadius: CGFloat = 10
		static let minimumContentInset: CGFloat = 8

		enum ContentStackView {
			static let spacing: CGFloat = 3
		}

		enum CameraIconImageView {
			static let image = UIImage(systemName: "camera.fill")
			static let tintColor: UIColor = .secondaryLabel
			static let widthAgainstButton: CGFloat = 0.4
			static let heightAgainstOwnWidth: CGFloat = 0.8
		}

		enum ImageCountLabel {
			static let font: UIFont.TextStyle = .callout
			static let textColor: UIColor = .secondaryLabel
			static let initialText: String = "0/5"
		}
	}
}
