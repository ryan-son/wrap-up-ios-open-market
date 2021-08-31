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

        enum PhotoCollectionView {
            static let sectionInset = UIEdgeInsets(top: 30, left: 20, bottom: 30, right: 20)
            static let sectionMinimumLineSpacing: CGFloat = 20
            static let itemSize = CGSize(width: 80, height: 80)
        }
    }

    private let intent: Intent
    private var viewModel: MarketItemRegisterViewModel?
    private lazy var imagePicker = ImagePicker(presentationController: self, delegate: self)
    private var photoCollectionViewCompactSizeClassHeightAnchor: NSLayoutConstraint?
    private var photoCollectionViewRegularSizeClassHeightAnchor: NSLayoutConstraint?

    init(intent: Intent) {
        self.intent = intent
        super.init(nibName: nil, bundle: nil)
    }

    @available(iOS, unavailable, message: "Use init(intent:) instead")
    required init?(coder: NSCoder) {
        self.intent = .register
        super.init(coder: coder)
    }

    private let photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(AddPhotoCollectionViewCell.self,
                                forCellWithReuseIdentifier: AddPhotoCollectionViewCell.reuseIdentifier)
        collectionView.register(PhotoCollectionViewCell.self,
                                forCellWithReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setAttributes()
        setDelegates()
        setupViews()
        setupConstraints()
    }

    func bind(with viewModel: MarketItemRegisterViewModel) {
        self.viewModel = viewModel

        viewModel.bind { [weak self] state in
            switch state {
            case .appendImage(let index):
                let indexPath = IndexPath(item: index + 1, section: .zero)
                self?.photoCollectionView.insertItems(at: [indexPath])
            case .deleteImage(let index):
                let indexPath = IndexPath(item: index + 1, section: .zero)
                self?.photoCollectionView.deleteItems(at: [indexPath])
            default:
                break
            }
        }
    }

    private func setAttributes() {
        title = intent == .register ? "Item Registration" : "Edit Item"
        view.backgroundColor = Style.backgroundColor
    }

    private func setDelegates() {
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
    }

    private func setupViews() {
        view.addSubview(photoCollectionView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            photoCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photoCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            photoCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])

        photoCollectionViewCompactSizeClassHeightAnchor =
            photoCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15)
        photoCollectionViewRegularSizeClassHeightAnchor =
            photoCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)

        photoCollectionViewCompactSizeClassHeightAnchor?.isActive = true
    }

    @objc private func showImagePicker() {
        guard let numberOfImages = viewModel?.images.count,
              numberOfImages <= Style.maxImageCount else { return }
        let addPhotoCellIndex = IndexPath(item: .zero, section: .zero)
        guard let addPhotoCell = photoCollectionView.cellForItem(at: addPhotoCellIndex) else { return }
        imagePicker.present(from: addPhotoCell)
    }

    @objc private func removePhoto(_ sender: UIButton) {
        guard let imageCount = viewModel?.images.count else { return }

        for index in .zero ..< imageCount {
            let indexPath = IndexPath(item: index + 1, section: .zero)
            guard let cell = photoCollectionView.cellForItem(at: indexPath) as? PhotoCollectionViewCell else { return }
            if cell.deleteButton == sender {
                viewModel?.removeImage(at: index)
            }
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        photoCollectionViewRegularSizeClassHeightAnchor?.isActive.toggle()
        photoCollectionViewCompactSizeClassHeightAnchor?.isActive.toggle()
    }
}

extension MarketItemRegisterViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let imageCount = viewModel?.images.count ?? .zero
        return imageCount + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
        case .zero:
            let addPhotoCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: AddPhotoCollectionViewCell.reuseIdentifier,
                for: indexPath
            )
            return addPhotoCell

        default:
            guard let photoCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier,
                    for: indexPath
            ) as? PhotoCollectionViewCell else { return UICollectionViewCell() }

            photoCell.addDeleteButtonTarget(target: self, action: #selector(removePhoto(_:)), for: .touchUpInside)

            guard let photoImage = viewModel?.images[indexPath.item - 1] else { return UICollectionViewCell() }
            let photoCellViewModel = PhotoCellViewModel(photoImage: photoImage)
            photoCell.bind(with: photoCellViewModel)
            photoCell.fire()

            return photoCell
        }
    }
}

extension MarketItemRegisterViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height * 0.7
        return CGSize(width: height, height: height)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Style.PhotoCollectionView.sectionMinimumLineSpacing
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let vertical = collectionView.frame.height * 0.1
        return UIEdgeInsets(top: vertical, left: 30, bottom: vertical, right: 30)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item {
        case .zero:
            showImagePicker()
        default:
            break
        }
    }
}

extension MarketItemRegisterViewController: ImagePickerDelegate {

    func didSelectImage(_ image: UIImage?, at url: URL?) {
        guard let image = image,
              let url = url else { return }
        viewModel?.appendImage(image, at: url)
    }
}
