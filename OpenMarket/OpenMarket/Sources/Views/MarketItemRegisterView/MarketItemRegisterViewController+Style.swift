//
//  MarketItemRegisterViewController+Style.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/09/01.
//

import UIKit

// MARK: - Namespaces

extension MarketItemRegisterViewController {

	enum Style {

		static let registerTitle: String = "Item Registration"
		static let editTitle: String = "Edit"
		static let backgroundColor: UIColor = .systemBackground
		static let placeholderTextColor: UIColor = .secondaryLabel
		static let layerColor: UIColor = .secondaryLabel
		static let textColor: UIColor = .label
		static let maxImageCount: Int = 5
		static let separatorSpacing: CGFloat = 15
		static let spacing: CGFloat = 10

		enum PhotoCollectionView {
			static let horizontalSectionInset: CGFloat = 30
			static let verticalSectionInsetAgainstCollectionViewHeight: CGFloat = 0.1
			static let sectionMinimumLineSpacing: CGFloat = 20
			static let itemSizeAgainstCollectionViewHeight: CGFloat = 0.6
			static let heightRatioAgainstPortraitViewHeight: CGFloat = 0.15
			static let heightRatioAgainstLandscapeViewHeight: CGFloat = 0.3
		}

		enum Constraint {
			static let currencyTextFieldWidth: CGFloat = 50
		}

		enum Alert {
			static let cannotExceedMaxImageCountAlertTitle: String = "사진은 최대 5장까지 첨부하실 수 있어요."
			static let contentNotFilledAlertTitle: String = "필수값이 모두 입력되지 않았어요."
			static let contentNotFilledAlertMessage: String = "할인가 이외의 값을 모두 입력해주세요."
			static let okActionTitle: String = "확인"
		}
	}
}
