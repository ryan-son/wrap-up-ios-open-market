//
//  ViewPhotoButton.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/08/31.
//

import UIKit

final class ViewPhotoButton: UIButton {

    private enum Style {

        static let borderColor: CGColor = UIColor.secondaryLabel.cgColor
        static let borderWidth: CGFloat = 0.5
        static let cornerRadius: CGFloat = 10

        enum DeleteButton {
            static let image = UIImage(systemName: "xmark.circle.fill")
            static let tintColor: UIColor = .label
            static let backgroundColor: UIColor = .systemBackground
            static let borderColor: CGColor = UIColor.systemBackground.cgColor
            static let borderWidth: CGFloat = 1.5
            static let size: CGFloat = 25
        }
    }

    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(Style.DeleteButton.image, for: .normal)
        button.tintColor = Style.DeleteButton.tintColor
        button.layer.borderColor = Style.DeleteButton.borderColor
        button.layer.borderWidth = Style.DeleteButton.borderWidth
        button.backgroundColor = Style.DeleteButton.backgroundColor
        button.layer.cornerRadius = Style.DeleteButton.size / 2
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init(image: UIImage) {
        super.init(frame: .zero)
        setStyle()
        setupViews()
        setupConstraints()
        setImage(image, for: .normal)

    }

    @available(iOS, unavailable, message: "Use init(image:) instead")
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setStyle() {
        layer.borderColor = Style.borderColor
        layer.borderWidth = Style.borderWidth
        layer.cornerRadius = Style.cornerRadius
        imageView?.layer.cornerRadius = Style.cornerRadius
        imageView?.contentMode = .scaleAspectFit
        imageView?.clipsToBounds = true
    }

    private func setupViews() {
        addSubview(deleteButton)
        addBorder()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            deleteButton.widthAnchor.constraint(equalToConstant: Style.DeleteButton.size),
            deleteButton.heightAnchor.constraint(equalToConstant: Style.DeleteButton.size),
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                   constant: Style.DeleteButton.size / 2),
            deleteButton.topAnchor.constraint(equalTo: topAnchor,
                                                   constant: -Style.DeleteButton.size / 2)
        ])
    }

    private func addBorder() {
        let layer = CALayer()
        layer.frame = CGRect(x: .zero, y: .zero, width: frame.size.width, height: frame.size.height)
        layer.borderColor = Style.borderColor
        layer.borderWidth = Style.borderWidth
        self.layer.addSublayer(layer)
        deleteButton.layer.insertSublayer(layer, at: .zero)
    }
}
