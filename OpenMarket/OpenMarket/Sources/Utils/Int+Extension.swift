//
//  Int+Extension.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/08/25.
//

import Foundation

extension NumberFormatter {

    static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension Int {

    func priceFormatted() -> String {
        return NumberFormatter.priceFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}
