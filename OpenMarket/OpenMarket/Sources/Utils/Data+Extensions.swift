//
//  Data+Extensions.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/09/01.
//

import Foundation

extension Data {

	mutating func append(_ string: String) {
		guard let data = string.data(using: .utf8) else { return }
		self.append(data)
	}
}
