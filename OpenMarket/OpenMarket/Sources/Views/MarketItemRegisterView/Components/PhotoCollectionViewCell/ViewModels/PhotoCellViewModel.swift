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

    private var photoImage: UIImage {
        didSet {
            DispatchQueue.main.async {
                self.listener?(self.photoImage)
            }
        }
    }

	// MARK: Binder

    private var listener: ((UIImage) -> Void)?

	// MARK: Initializers

    init(photoImage: UIImage) {
        self.photoImage = photoImage
    }

	// MARK: Binding methods

    func bind(_ listener: @escaping ((UIImage) -> Void)) {
        self.listener = listener
    }

    func fire() {
        listener?(photoImage)
    }
}
