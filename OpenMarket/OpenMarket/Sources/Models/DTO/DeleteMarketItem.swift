//
//  DeleteMarketItem.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/08/30.
//

import Foundation

protocol Uploadable {

    var password: String { get }
}

struct DeleteMarketItem: Encodable, Uploadable {

    let password: String
}
