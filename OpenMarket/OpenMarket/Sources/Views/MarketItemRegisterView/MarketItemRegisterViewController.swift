//
//  MarketItemRegisterViewController.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/08/29.
//

import UIKit

final class MarketItemRegisterViewController: UIViewController {

    enum Intent {
        case register, edit
    }

    private enum Style {

        static let placeholderTextColor: UIColor = .secondaryLabel
        static let layerColor: UIColor = .secondaryLabel
        static let textColor: UIColor = .label
        static let maxImageCount: Int = 5

        enum PhotoStackView {
            static let spacing: CGFloat = 20
        }

        enum ViewPhotoButton {
            static let size: CGFloat = 80
        }

        enum Constraint {
            static let viewOffsetFromTop: CGFloat = 50
        }
    }

    private let intent: Intent
    private var viewModel: MarketItemRegisterViewModel?
    private lazy var imagePicker = ImagePicker(presentationController: self, delegate: self)

    init(intent: Intent) {
        self.intent = intent
        super.init(nibName: nil, bundle: nil)
    }

    @available(iOS, unavailable, message: "Use init(intent:) instead")
    required init?(coder: NSCoder) {
        self.intent = .register
        super.init(coder: coder)
    }

    private let photoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = Style.PhotoStackView.spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let addPhotoButton: UIButton = {
        let button = AddPhotoButton()
        button.addTarget(self, action: #selector(showImagePicker), for: .touchUpInside)
        return button
    }()

    private var viewPhotoButtons: [UIButton] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func bind(with viewModel: MarketItemRegisterViewModel) {
        self.viewModel = viewModel

        viewModel.bind { [weak self] state in
            switch state {
            case .appendImage(let image):
                self?.appendViewPhotoButton(with: image)
            case .deleteImage(let index):
                self?.deleteViewPhotoButton(at: index)
            default:
                break
            }
        }
    }

    private func setupViews() {
        photoStackView.addArrangedSubview(addPhotoButton)
        view.addSubview(photoStackView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            photoStackView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            photoStackView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            photoStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                constant: Style.Constraint.viewOffsetFromTop),
            addPhotoButton.widthAnchor.constraint(equalToConstant: Style.ViewPhotoButton.size),
            addPhotoButton.heightAnchor.constraint(equalTo: addPhotoButton.widthAnchor)
        ])
    }

    @objc private func showImagePicker() {
        guard let numberOfImages = viewModel?.images.count,
              numberOfImages <= Style.maxImageCount else { return }
        imagePicker.present(from: addPhotoButton)
    }

    private func appendViewPhotoButton(with image: UIImage) {
        let viewPhotoButton = ViewPhotoButton(image: image)
        viewPhotoButton.alpha = .zero
        photoStackView.addArrangedSubview(viewPhotoButton)
        viewPhotoButtons.append(viewPhotoButton)

        NSLayoutConstraint.activate([
            viewPhotoButton.widthAnchor.constraint(equalTo: addPhotoButton.widthAnchor),
            viewPhotoButton.heightAnchor.constraint(equalTo: addPhotoButton.heightAnchor)
        ])

        UIView.animate(withDuration: 0.6) {
            viewPhotoButton.alpha = 1
        }
    }

    private func deleteViewPhotoButton(at index: Int) {
        guard index < viewPhotoButtons.count else { return }
        let buttonToDelete = viewPhotoButtons[index]
        photoStackView.removeArrangedSubview(buttonToDelete)
    }
}

extension MarketItemRegisterViewController: ImagePickerDelegate {

    func didSelectImage(_ image: UIImage?, at url: URL?) {
        guard let image = image,
              let url = url else { return }
        viewModel?.appendImage(image, at: url)
    }
}
