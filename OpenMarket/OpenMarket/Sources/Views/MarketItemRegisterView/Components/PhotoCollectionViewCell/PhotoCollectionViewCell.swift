//
//  PhotoCollectionViewCell.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/09/01.
//

import UIKit

final class PhotoCollectionViewCell: UICollectionViewCell {

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

    static let reuseIdentifier: String = "PhotoCollectionViewCell"
    private var viewModel: PhotoCellViewModel?

    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = Style.cornerRadius
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let deleteButton: UIButton = {
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

    func bind(with viewModel: PhotoCellViewModel) {
        self.viewModel = viewModel

        viewModel.bind { [weak self] photo in
            self?.photoImageView.image = photo
        }
    }

    func fire() {
        viewModel?.fire()
    }

    private func setStyle() {
        contentView.layer.borderColor = Style.borderColor
        contentView.layer.borderWidth = Style.borderWidth
        contentView.layer.cornerRadius = Style.cornerRadius
    }

    private func setupViews() {
        contentView.addSubview(photoImageView)
        contentView.addSubview(deleteButton)
        addBorder()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: Style.DeleteButton.size),
            deleteButton.heightAnchor.constraint(equalToConstant: Style.DeleteButton.size),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                   constant: Style.DeleteButton.size / 2),
            deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor,
                                              constant: -Style.DeleteButton.size / 2)
        ])
    }

    private func addBorder() {
        let layer = CALayer()
        layer.frame = CGRect(x: .zero, y: .zero, width: contentView.frame.size.width, height: contentView.frame.size.height)
        layer.borderColor = Style.borderColor
        layer.borderWidth = Style.borderWidth
        contentView.layer.addSublayer(layer)
        deleteButton.layer.insertSublayer(layer, at: .zero)
    }

    func addDeleteButtonTarget(target: Any?, action: Selector, for event: UIControl.Event) {
        deleteButton.addTarget(target, action: action, for: event)
    }
}
