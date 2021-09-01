//
//  SeparatorView.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/09/01.
//

import UIKit

final class SeparatorView: UIView {

	// MARK: Initializers

    init() {
        super.init(frame: .zero)
        setStyle()
        setupConstraints()
    }

    @available(iOS, unavailable, message: "Use init() instead")
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

	// MARK: Set up styles and views

    private func setStyle() {
        backgroundColor = Style.backgroundColor
    }

    private func setupConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: Style.height).isActive = true
    }
}

// MARK: - Namespaces

extension SeparatorView {

	private enum Style {

		static let backgroundColor: UIColor = .tertiaryLabel
		static let height: CGFloat = 0.5
	}
}
