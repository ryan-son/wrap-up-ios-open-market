//
//  PhotoCellViewModel.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/09/01.
//

import Foundation
import UIKit.UIImage

final class PhotoCellViewModel {

	// MARK: Bound properties

    private(set) var photoImage: UIImage? {
        didSet {
            DispatchQueue.main.async {
                guard let photoImage = self.photoImage else { return }
                self.listener?(photoImage)
            }
        }
    }

	// MARK: Binder

    private var listener: ((UIImage) -> Void)?

	// MARK: Binding methods

    func bind(_ listener: @escaping ((UIImage) -> Void)) {
        self.listener = listener
    }

    func setImage(_ image: UIImage) {
        photoImage = image
    }
}
