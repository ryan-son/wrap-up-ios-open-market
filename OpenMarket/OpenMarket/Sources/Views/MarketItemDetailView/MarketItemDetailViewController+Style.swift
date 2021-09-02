//
//  MarketItemDetailViewController+Style.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/09/02.
//

import UIKit

// MARK: - Namespaces

extension MarketItemDetailViewController {

    enum Style {

        static let navigationTitle: String = "Item Detail"
        static let backButtonTitle: String = "< Back"
        static let moreActionButtonImage = UIImage(systemName: "ellipsis")
        static let outOfStockString: String = "품절"
        static let outOfStockLabelColor: UIColor = .systemOrange
        static let backgroundColor: UIColor = .systemBackground
        static let spacing: CGFloat = 20
        static let waitingTimeAfterMarketItemRegistered: TimeInterval = 1.2
        static let imageDissolveAnimationTime: TimeInterval = 0.6

        enum ImageScrollViewPageControl {
            static let currentPageIndicatorTintColor: UIColor = .systemOrange
            static let pageIndicatorTintColor: UIColor = .systemGray.withAlphaComponent(0.8)
        }

        enum TitleLabel {
            static let font: UIFont.TextStyle = .title1
            static let textColor: UIColor = .label
        }

        enum StockLabel {
            static let font: UIFont.TextStyle = .body
            static let textColor: UIColor = .secondaryLabel
        }

        enum DiscountedPriceLabel {
            static let font: UIFont.TextStyle = .callout
            static let textColor: UIColor = .secondaryLabel
        }

        enum PriceLabel {
            static let font: UIFont.TextStyle = .headline
            static let textColor: UIColor = .label
        }

        enum BodyTextLabel {
            static let font: UIFont.TextStyle = .title3
            static let textColor: UIColor = .label
        }

        enum Alert {
            static let moreActionTitle: String = "무엇을 해볼까요?"
            static let editItemActionTitle: String = "상품 수정"
            static let deleteItemActionTitle: String = "상품 삭제"
            static let inputPasswordTitle: String = "비밀번호를 입력해주세요."
            static let inputPasswordTextFieldPlaceholderText: String = "비밀번호"
            static let wrongPasswordInputTitle: String = "비밀번호가 다릅니다."
            static let marketItemDeletedTitle: String = "삭제되었습니다."
            static let retryActionTitle: String = "재시도"
            static let okActionTitle: String = "확인"
            static let cancelActionTitle: String = "취소"
        }
    }
}
