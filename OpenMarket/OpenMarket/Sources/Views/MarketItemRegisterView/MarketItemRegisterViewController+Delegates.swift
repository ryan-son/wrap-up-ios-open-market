//
//  MarketItemRegisterViewController+Delegates.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/09/01.
//

import UIKit

// MARK: - UICollectionViewDataSource

extension MarketItemRegisterViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let imageCount = viewModel?.images.count ?? .zero
        return imageCount + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
        case .zero:
            let addPhotoCell = collectionView.dequeueReusableCell(withReuseIdentifier: AddPhotoCollectionViewCell.reuseIdentifier, for: indexPath)
            return addPhotoCell
        default:
            guard let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier, for: indexPath)
                    as? PhotoCollectionViewCell else { return UICollectionViewCell() }

            photoCell.addDeleteButtonTarget(target: self, action: #selector(removePhoto(_:)), for: .touchUpInside)

            guard let photoImage = viewModel?.images[indexPath.item - 1] else { return UICollectionViewCell() }
            let photoCellViewModel = PhotoCellViewModel(photoImage: photoImage)
            photoCell.bind(with: photoCellViewModel)
            photoCell.fire()
            return photoCell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MarketItemRegisterViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height * Style.PhotoCollectionView.itemSizeAgainstCollectionViewHeight
        return CGSize(width: height, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Style.PhotoCollectionView.sectionMinimumLineSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let vertical = collectionView.frame.height * Style.PhotoCollectionView.verticalSectionInsetAgainstCollectionViewHeight
        return UIEdgeInsets(top: vertical,
                            left: Style.PhotoCollectionView.horizontalSectionInset,
                            bottom: vertical,
                            right: Style.PhotoCollectionView.horizontalSectionInset)
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

// MARK: - ImagePickerDelegate

extension MarketItemRegisterViewController: ImagePickerDelegate {

    func didSelectImage(_ image: UIImage?) {
        guard let image = image else { return }
        viewModel?.appendImage(image)
    }
}

// MARK: - PlaceholderTextViewDelegate

extension MarketItemRegisterViewController: PlaceholderTextViewDelegate {

	func didFillTextView(category: PlaceholderTextView.TextViewType, with text: String) {
		viewModel?.setMarketItemInfo(of: category, with: text)
	}
}

// MARK: - CurrencyTextFieldDelegate

extension MarketItemRegisterViewController: CurrencyTextFieldDelegate {

	func didFillTextField(with text: String) {
		viewModel?.setMarketItemCurrency(with: text)
	}
}
