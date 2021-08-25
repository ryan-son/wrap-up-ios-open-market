//
//  UIImage+Extension.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/08/25.
//

import UIKit.UIImage

extension UIImage {

    func resizedImage(targetSize: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}
