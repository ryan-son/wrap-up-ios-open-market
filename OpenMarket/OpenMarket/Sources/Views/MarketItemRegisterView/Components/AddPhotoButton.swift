//
//  AddPhotoButton.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/08/31.
//

import UIKit

final class AddPhotoButton: UIButton {

    private enum Style {

        static let borderColor: CGColor = UIColor.secondaryLabel.cgColor
        static let borderWidth: CGFloat = 0.5
        static let cornerRadius: CGFloat = 10
        static let minimumContentInset: CGFloat = 15

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

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.spacing = Style.ContentStackView.spacing
        stackView.isUserInteractionEnabled = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let cameraIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Style.CameraIconImageView.image
        imageView.tintColor = Style.CameraIconImageView.tintColor
        imageView.isUserInteractionEnabled = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let imageCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: Style.ImageCountLabel.font)
        label.textColor = Style.ImageCountLabel.textColor
        label.text = Style.ImageCountLabel.initialText
        label.isUserInteractionEnabled = false
        return label
    }()

    init() {
        super.init(frame: .zero)
        setStyle()
        setupViews()
        setupConstraints()
    }

    @available(iOS, unavailable, message: "Use init() instead")
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setStyle() {
        layer.borderColor = Style.borderColor
        layer.borderWidth = Style.borderWidth
        layer.cornerRadius = Style.cornerRadius
    }

    private func setupViews() {
        contentStackView.addArrangedSubview(cameraIconImageView)
        contentStackView.addArrangedSubview(imageCountLabel)

        addSubview(contentStackView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStackView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor,
                                                  constant: Style.minimumContentInset),
            contentStackView.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor,
                                                     constant: -Style.minimumContentInset),
            contentStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            cameraIconImageView.widthAnchor.constraint(equalTo: widthAnchor,
                                                       multiplier: Style.CameraIconImageView.widthAgainstButton),
            cameraIconImageView.heightAnchor.constraint(equalTo: cameraIconImageView.widthAnchor,
                                                        multiplier: Style.CameraIconImageView.heightAgainstOwnWidth)
        ])
    }
}
