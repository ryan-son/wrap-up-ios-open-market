//
//  MarketItemList.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/08/24.
//

import Foundation

struct MarketItemList: Decodable {

    let page: Int
    let items: [MarketItem]
}
