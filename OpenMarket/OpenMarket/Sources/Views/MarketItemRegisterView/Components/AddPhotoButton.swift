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

        enum ContentStackView {
            static let spacing: CGFloat = 8
        }

        enum CameraIconImageView {
            static let image = UIImage(systemName: "camera.fill")
            static let tintColor: UIColor = .secondaryLabel
            static let widthAgainstButton: CGFloat = 0.3
            static let heightAgainstOwnWidth: CGFloat = 0.8
        }

        enum ImageCountLabel {
            static let font: UIFont.TextStyle = .footnote
            static let textColor: UIColor = .secondaryLabel
        }
    }

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = Style.ContentStackView.spacing
        return stackView
    }()

    private let cameraIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Style.CameraIconImageView.image
        imageView.tintColor = Style.CameraIconImageView.tintColor
        return imageView
    }()

    private let imageCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: Style.ImageCountLabel.font)
        label.textColor = Style.ImageCountLabel.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init() {
        super.init(frame: .zero)
        setStyle()
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
            cameraIconImageView.widthAnchor.constraint(equalTo: widthAnchor,
                                                       multiplier: Style.CameraIconImageView.widthAgainstButton),
            cameraIconImageView.heightAnchor.constraint(equalTo: cameraIconImageView.widthAnchor,
                                                        multiplier: Style.CameraIconImageView.heightAgainstOwnWidth)
        ])
    }
}
