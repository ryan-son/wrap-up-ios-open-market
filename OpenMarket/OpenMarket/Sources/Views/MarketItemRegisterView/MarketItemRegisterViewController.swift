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

        static let backgroundColor: UIColor = .systemBackground
        static let placeholderTextColor: UIColor = .secondaryLabel
        static let layerColor: UIColor = .secondaryLabel
        static let textColor: UIColor = .label
        static let maxImageCount: Int = 5

        enum PhotoStackView {
            static let spacing: CGFloat = 20
        }

        enum ViewPhotoButton {
            static let size: CGFloat = 75
        }

        enum Constraint {
            static let viewOffsetFromTop: CGFloat = 30
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
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = Style.PhotoStackView.spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let addPhotoButton: AddPhotoButton = {
        let button = AddPhotoButton()
        button.addTarget(self, action: #selector(showImagePicker), for: .touchUpInside)
        return button
    }()

    private var viewPhotoButtons: [ViewPhotoButton] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setAttributes()
        setupViews()
        setupConstraints()
    }

    func bind(with viewModel: MarketItemRegisterViewModel) {
        self.viewModel = viewModel

        viewModel.bind { [weak self] state in
            switch state {
            case .appendImage(let index, let image):
                self?.appendViewPhotoButton(at: index, with: image)
            case .deleteImage(let index):
                self?.removeViewPhotoButton(at: index)
            default:
                break
            }
        }
    }

    private func setAttributes() {
        title = intent == .register ? "Item Registration" : "Edit Item"
        view.backgroundColor = Style.backgroundColor
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

    private func appendViewPhotoButton(at index: Int, with image: UIImage) {
        let viewPhotoButton = ViewPhotoButton(image: image)
        viewPhotoButton.addDeleteButtonTarget(target: self, action: #selector(removePhoto), for: .touchUpInside)
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

    @objc private func removePhoto(_ sender: UIButton) {
        for index in viewPhotoButtons.indices where sender == viewPhotoButtons[index].deleteButton {
            viewModel?.removeImage(at: index)
        }
    }

    private func removeViewPhotoButton(at index: Int) {
        guard index < viewPhotoButtons.count else { return }
        let buttonToDelete = viewPhotoButtons[index]
        buttonToDelete.removeFromSuperview()
        viewPhotoButtons.remove(at: index)
    }
}

extension MarketItemRegisterViewController: ImagePickerDelegate {

    func didSelectImage(_ image: UIImage?, at url: URL?) {
        guard let image = image,
              let url = url else { return }
        viewModel?.appendImage(image, at: url)
    }
}
