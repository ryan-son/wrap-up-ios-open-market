//
//  ViewPhotoButton.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/08/31.
//

import UIKit

final class ViewPhotoButton: UIButton {

    private enum Style {

        enum DeleteButton {
            static let image = UIImage(systemName: "xmark")
            static let backgroundColor: UIColor = .label
            static let tintColor: UIColor = .systemBackground
            static let borderColor: UIColor = .systemBackground
            static let borderWidth: CGFloat = 1.5
            static let cornerRadius: CGFloat = 15
            static let widthAgainstSuperview: CGFloat = 0.2
        }
    }

    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(Style.DeleteButton.image, for: .normal)
        button.backgroundColor = Style.DeleteButton.backgroundColor
        button.tintColor = Style.DeleteButton.tintColor
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init(image: UIImage) {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
        setBackgroundImage(image, for: .normal)
    }

    @available(iOS, unavailable, message: "Use init(image:) instead")
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupViews() {
        addSubview(deleteButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            deleteButton.widthAnchor.constraint(equalTo: widthAnchor,
                                                multiplier: Style.DeleteButton.widthAgainstSuperview),
            deleteButton.heightAnchor.constraint(equalTo: deleteButton.heightAnchor)
        ])
    }
}
