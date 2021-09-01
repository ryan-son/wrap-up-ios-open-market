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

    // MARK: Namespaces

    enum Style {

        static let backgroundColor: UIColor = .systemBackground
        static let placeholderTextColor: UIColor = .secondaryLabel
        static let layerColor: UIColor = .secondaryLabel
        static let textColor: UIColor = .label
        static let maxImageCount: Int = 5
        static let separatorSpacing: CGFloat = 15
        static let spacing: CGFloat = 10

        enum PhotoCollectionView {
            static let sectionInset = UIEdgeInsets(top: 30, left: 20, bottom: 30, right: 20)
            static let sectionMinimumLineSpacing: CGFloat = 20
            static let itemSize = CGSize(width: 50, height: 50)
            static let heightRatioAgainstPortraitViewHeight: CGFloat = 0.15
            static let heightRatioAgainstLandscapeViewHeight: CGFloat = 0.3
        }

        enum Constraint {
            static let currencyTextFieldWidth: CGFloat = 50
        }
    }

    // MARK: Properties

    private let intent: Intent
    private(set) var viewModel: MarketItemRegisterViewModel?
    private lazy var imagePicker = ImagePicker(presentationController: self, delegate: self)
    private var contentScrollViewBottomAnchor: NSLayoutConstraint?
    private var photoCollectionViewCompactSizeClassHeightAnchor: NSLayoutConstraint?
    private var photoCollectionViewRegularSizeClassHeightAnchor: NSLayoutConstraint?

    // MARK: Initializers

    init(intent: Intent) {
        self.intent = intent
        super.init(nibName: nil, bundle: nil)
    }

    @available(iOS, unavailable, message: "Use init(intent:) instead")
    required init?(coder: NSCoder) {
        self.intent = .register
        super.init(coder: coder)
    }

    // MARK: Views

    private let contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isDirectionalLockEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isDirectionalLockEnabled = true
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(AddPhotoCollectionViewCell.self, forCellWithReuseIdentifier: AddPhotoCollectionViewCell.reuseIdentifier)
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private let photoSectionSeparatorView = SeparatorView()
    private let titleInputTextView = PlaceholderTextView(type: .title)
    private let titleSectionSeparatorView = SeparatorView()
    private let currencyPickerTextField = CurrencyTextField()
    private let discountedPriceInputTextView: PlaceholderTextView = {
        let textView = PlaceholderTextView(type: .discountedPrice)
        textView.keyboardType = .decimalPad
        return textView
    }()

    private let priceInputTextView: PlaceholderTextView = {
        let textView = PlaceholderTextView(type: .price)
        textView.keyboardType = .decimalPad
        return textView
    }()

    private let priceSectionSeparatorView = SeparatorView()

    private let stockInputTextView: PlaceholderTextView = {
        let textView = PlaceholderTextView(type: .stock)
        textView.keyboardType = .decimalPad
        return textView
    }()

    private let passwordInputTextView = PlaceholderTextView(type: .password)
    private let stockSectionSeparatorView = SeparatorView()
    private let descriptionsInputTextView = PlaceholderTextView(type: .descriptions)

    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setAttributes()
        setDelegates()
        setupViews()
        setupConstraints()
        addKeyboardNotificationObservers()
        addKeyboardDismissGestureRecognizer()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeKeyboardNotificationObservers()
    }

    // MARK: Data binding

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

    // MARK: Set attributes of the view controller

    private func setAttributes() {
        title = intent == .register ? "Item Registration" : "Edit Item"
        view.backgroundColor = Style.backgroundColor
    }

    private func setDelegates() {
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
    }

    // MARK: Actions

    @objc func showImagePicker() {
        guard let numberOfImages = viewModel?.images.count else { return }
        guard numberOfImages < Style.maxImageCount else {
            showCannotExceedMaxImageCountAlert()
            return
        }

        let addPhotoCellIndex = IndexPath(item: .zero, section: .zero)
        guard let addPhotoCell = photoCollectionView.cellForItem(at: addPhotoCellIndex) else { return }
        imagePicker.present(from: addPhotoCell)
    }

    @objc func removePhoto(_ sender: UIButton) {
        guard let imageCount = viewModel?.images.count else { return }

        for index in .zero ..< imageCount {
            let indexPath = IndexPath(item: index + 1, section: .zero)
            guard let cell = photoCollectionView.cellForItem(at: indexPath) as? PhotoCollectionViewCell else { return }
            if cell.deleteButton == sender {
                viewModel?.removeImage(at: index)
            }
        }
    }

    // MARK: Alerts

    private func showCannotExceedMaxImageCountAlert() {
        let alert = UIAlertController(title: "사진은 최대 5장까지 첨부하실 수 있어요.", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }

    // MARK: Handling keyboard notifications

    private func addKeyboardNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        contentScrollView.contentInset.bottom = keyboardFrame.height / 2
        contentScrollViewBottomAnchor?.constant = -keyboardFrame.height

        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        let contentInset: UIEdgeInsets = .zero
        contentScrollView.contentInset = contentInset
        contentScrollView.scrollIndicatorInsets = contentInset
        contentScrollViewBottomAnchor?.constant = .zero

        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }

    private func removeKeyboardNotificationObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: Dismiss keyboard by tapping

    func addKeyboardDismissGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: Adjust layout upon view transition

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        photoCollectionViewCompactSizeClassHeightAnchor?.isActive.toggle()
        photoCollectionViewRegularSizeClassHeightAnchor?.isActive.toggle()
    }
}

// MARK: - Set up views and constraints

extension MarketItemRegisterViewController {

    private func setupViews() {
        contentScrollView.addSubview(photoCollectionView)
        contentScrollView.addSubview(photoSectionSeparatorView)
        contentScrollView.addSubview(titleInputTextView)
        contentScrollView.addSubview(titleSectionSeparatorView)
        contentScrollView.addSubview(currencyPickerTextField)
        contentScrollView.addSubview(priceInputTextView)
        contentScrollView.addSubview(discountedPriceInputTextView)
        contentScrollView.addSubview(priceSectionSeparatorView)
        contentScrollView.addSubview(stockInputTextView)
        contentScrollView.addSubview(passwordInputTextView)
        contentScrollView.addSubview(stockSectionSeparatorView)
        contentScrollView.addSubview(descriptionsInputTextView)
        view.addSubview(contentScrollView)
    }

    private func setupConstraints() {
        setupContentScrollViewConstraints()
        setupPhotoCollectionViewConstraints()
        setupSeparatorViewConstraints()

        NSLayoutConstraint.activate([
            titleInputTextView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            titleInputTextView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            titleInputTextView.topAnchor.constraint(equalTo: photoSectionSeparatorView.bottomAnchor,
                                                    constant: Style.separatorSpacing),

            currencyPickerTextField.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            currencyPickerTextField.widthAnchor.constraint(equalToConstant: Style.Constraint.currencyTextFieldWidth),
            currencyPickerTextField.topAnchor.constraint(equalTo: titleSectionSeparatorView.bottomAnchor, constant: Style.separatorSpacing),
            currencyPickerTextField.bottomAnchor.constraint(equalTo: discountedPriceInputTextView.bottomAnchor),

            priceInputTextView.leadingAnchor.constraint(equalTo: currencyPickerTextField.trailingAnchor, constant: Style.spacing),
            priceInputTextView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            priceInputTextView.topAnchor.constraint(equalTo: titleSectionSeparatorView.bottomAnchor, constant: Style.separatorSpacing),

            discountedPriceInputTextView.leadingAnchor.constraint(equalTo: currencyPickerTextField.trailingAnchor, constant: Style.spacing),
            discountedPriceInputTextView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            discountedPriceInputTextView.topAnchor.constraint(equalTo: priceInputTextView.bottomAnchor),

            stockInputTextView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            stockInputTextView.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -Style.spacing),
            stockInputTextView.topAnchor.constraint(equalTo: priceSectionSeparatorView.bottomAnchor, constant: Style.separatorSpacing),

            passwordInputTextView.leadingAnchor.constraint(equalTo: stockInputTextView.trailingAnchor, constant: Style.spacing),
            passwordInputTextView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            passwordInputTextView.topAnchor.constraint(equalTo: priceSectionSeparatorView.bottomAnchor, constant: Style.separatorSpacing),

            descriptionsInputTextView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            descriptionsInputTextView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            descriptionsInputTextView.topAnchor.constraint(equalTo: stockSectionSeparatorView.bottomAnchor, constant: Style.separatorSpacing)
        ])
    }

    private func setupContentScrollViewConstraints() {
        contentScrollViewBottomAnchor = contentScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        contentScrollViewBottomAnchor?.isActive = true

        NSLayoutConstraint.activate([
            contentScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            contentScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            contentScrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: view.widthAnchor),
            contentScrollView.contentLayoutGuide.topAnchor.constraint(equalTo: photoCollectionView.topAnchor),
            contentScrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: descriptionsInputTextView.bottomAnchor)
        ])
    }

    private func setupPhotoCollectionViewConstraints() {
        NSLayoutConstraint.activate([
            photoCollectionView.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor),
            photoCollectionView.trailingAnchor.constraint(equalTo: contentScrollView.trailingAnchor),
            photoCollectionView.topAnchor.constraint(equalTo: contentScrollView.topAnchor)
        ])

        photoCollectionViewCompactSizeClassHeightAnchor =
            photoCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: Style.PhotoCollectionView.heightRatioAgainstPortraitViewHeight)
        photoCollectionViewRegularSizeClassHeightAnchor =
            photoCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: Style.PhotoCollectionView.heightRatioAgainstLandscapeViewHeight)

        if traitCollection.horizontalSizeClass == .compact {
            photoCollectionViewCompactSizeClassHeightAnchor?.isActive = true
        } else {
            photoCollectionViewRegularSizeClassHeightAnchor?.isActive = true
        }
    }

    private func setupSeparatorViewConstraints() {
        NSLayoutConstraint.activate([
            photoSectionSeparatorView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            photoSectionSeparatorView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            photoSectionSeparatorView.topAnchor.constraint(equalTo: photoCollectionView.bottomAnchor),

            titleSectionSeparatorView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            titleSectionSeparatorView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            titleSectionSeparatorView.topAnchor.constraint(equalTo: titleInputTextView.bottomAnchor, constant: Style.separatorSpacing),

            priceSectionSeparatorView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            priceSectionSeparatorView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            priceSectionSeparatorView.topAnchor.constraint(equalTo: discountedPriceInputTextView.bottomAnchor, constant: Style.separatorSpacing),

            stockSectionSeparatorView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            stockSectionSeparatorView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            stockSectionSeparatorView.topAnchor.constraint(equalTo: stockInputTextView.bottomAnchor, constant: Style.separatorSpacing)
        ])
    }
}
