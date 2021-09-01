//
//  MarketItemRepresentable.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/09/01.
//

import UIKit

protocol MarketItemRepresentable: UICollectionViewCell {

	func bind(with viewModel: MarketItemCellViewModel)
	func fire()
}
