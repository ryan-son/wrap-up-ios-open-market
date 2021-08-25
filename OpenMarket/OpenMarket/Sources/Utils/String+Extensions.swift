//
//  String+Extensions.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/08/25.
//

import UIKit

extension String {

    func strikeThrough() -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: .zero, length: attributedString.length))
        return attributedString
    }
}
