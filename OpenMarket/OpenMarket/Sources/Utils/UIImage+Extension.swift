//
//  UIImage+Extension.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/08/25.
//

import UIKit.UIImage

extension UIImage {

    func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image { _ in
            draw(in: CGRect(origin: .zero, size: canvas))
        }
    }

    func compress(to kb: Int, allowedMargin: CGFloat = 0.2) -> Data {
        let bytes = kb * 1024
        var compression: CGFloat = 1.0
        var holderImage = self
        var isCompleted = false
        while !isCompleted {
            if let data = holderImage.jpegData(compressionQuality: 1.0) {
                if data.count <= bytes {
                    isCompleted = true
                    return data
                } else {
                    compression /= 2
                }
            }
            guard let resizedImage = holderImage.resized(withPercentage: compression) else { break }
            holderImage = resizedImage
        }
        return Data()
    }
}
