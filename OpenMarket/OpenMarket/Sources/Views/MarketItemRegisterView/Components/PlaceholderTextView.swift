//
//  PlaceholderTextView.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/09/01.
//

import UIKit

protocol PlaceholderTextViewDelegate: AnyObject {

	func didFillTextView(category: PlaceholderTextView.TextViewType, with text: String)
}

final class PlaceholderTextView: UITextView {

    enum TextViewType: String {
        case title
        case discountedPrice
        case price
        case stock
        case password
        case descriptions
    }

	// MARK: Properties

    private let type: TextViewType
    private var placeholderText: String?
	weak var placeholderTextViewDelegate: PlaceholderTextViewDelegate?

	// MARK: Initializers

    init(type: TextViewType) {
        self.type = type
        super.init(frame: .zero, textContainer: .none)
        setPlaceholderText()
        setStyle()
        delegate = self
        translatesAutoresizingMaskIntoConstraints = false
    }

    @available(iOS, unavailable, message: "Use init(type:) instead")
    required init?(coder: NSCoder) {
        self.type = .title
        super.init(coder: coder)
    }

	// MARK: Set up styles and views

    private func placeholderText(type: TextViewType) -> String {
        switch type {
        case .title:
            return PlaceholderText.title
        case .discountedPrice:
            return PlaceholderText.discountedPrice
        case .price:
            return PlaceholderText.price
        case .stock:
            return PlaceholderText.stock
        case .password:
            return PlaceholderText.password
        case .descriptions:
            return PlaceholderText.descriptions
        }
    }

    private func setStyle() {
        font = UIFont.preferredFont(forTextStyle: Style.font)
        textColor = text == placeholderText ? Style.placeholderTextColor : Style.textColor
        isScrollEnabled = false
		autocorrectionType = .no
        accessibilityIdentifier = type.rawValue
    }

    private func setPlaceholderText() {
        placeholderText = placeholderText(type: type)
        text = text.isEmpty ? placeholderText : text
    }
}

// MARK: - UITextViewDelegate

extension PlaceholderTextView: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        text = text == placeholderText ? "" : text
        textColor = Style.textColor
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if text.isEmpty {
            textColor = Style.placeholderTextColor
            text = placeholderText(type: type)
		}
    }

	func textViewDidChange(_ textView: UITextView) {
		placeholderTextViewDelegate?.didFillTextView(category: type, with: text)
	}
}

// MARK: - Namespaces

extension PlaceholderTextView {

	private enum Style {

		static let font: UIFont.TextStyle = .body
		static let textColor: UIColor = .label
		static let placeholderTextColor: UIColor = .tertiaryLabel
	}

	enum PlaceholderText {
		static let title: String = "글 제목"
		static let discountedPrice: String = "할인 가격 (선택사항)"
		static let price: String = "가격"
		static let stock: String = "잔여수량"
		static let password: String = "비밀번호"
		static let descriptions: String = "글 내용을 작성해주세요."
	}
}
