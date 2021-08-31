//
//  PhotoCellViewModel.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/09/01.
//

import Foundation
import UIKit.UIImage

final class PhotoCellViewModel {

    private var photoImage: UIImage {
        didSet {
            DispatchQueue.main.async {
                self.listener?(self.photoImage)
            }
        }
    }
    private var listener: ((UIImage) -> Void)?

    init(photoImage: UIImage) {
        self.photoImage = photoImage
    }

    func bind(_ listener: @escaping ((UIImage) -> Void)) {
        self.listener = listener
    }

    func fire() {
        listener?(photoImage)
    }
}
