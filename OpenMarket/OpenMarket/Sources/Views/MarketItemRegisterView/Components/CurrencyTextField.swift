//
//  CurrencyTextField.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/09/01.
//

import UIKit

protocol CurrencyTextFieldDelegate: AnyObject {

	func didFillTextField(with text: String)
}

final class CurrencyTextField: UITextField {

	// MARK: Properties

    private let pickerView = UIPickerView()
    private let currencies: [String] = ["KRW", "USD", "JPY", "CNY", "GBP"]
    private var selectedCurrency: String?
	weak var currencyTextFieldDelegate: CurrencyTextFieldDelegate?

	// MARK: Initializers

    init() {
        super.init(frame: .zero)
        setStyle()
        setDelegates()
        inputView = pickerView
        setToolBarButtonToDismissPickerView()
        translatesAutoresizingMaskIntoConstraints = false
    }

    @available(iOS, unavailable, message: "Use init() instead")
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

	// MARK: Set up styles and views

    private func setStyle() {
        font = UIFont.preferredFont(forTextStyle: Style.font)
        textColor = Style.textColor
        placeholder = Style.placeholderText
        textAlignment = .center
    }

    private func setDelegates() {
        pickerView.delegate = self
        pickerView.dataSource = self
    }

    private func setToolBarButtonToDismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(endEdit))
        toolBar.setItems([doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        inputAccessoryView = toolBar
    }

    @objc private func endEdit() {
        endEditing(true)
		guard let text = text,
			  !text.isEmpty && text != Style.placeholderText else { return }
		currencyTextFieldDelegate?.didFillTextField(with: text)
    }

	// MARK: Overriden methods to hide cursor

    override func caretRect(for position: UITextPosition) -> CGRect {
        return .zero
    }

    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        return []
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}

// MARK: - UIPickerViewDataSource

extension CurrencyTextField: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }
}

// MARK: - UIPickerViewDelegate

extension CurrencyTextField: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencies[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCurrency = currencies[row]
        text = selectedCurrency
    }
}

// MARK: - Namespaces

extension CurrencyTextField {

	private enum Style {

		static let font: UIFont.TextStyle = .body
		static let textColor: UIColor = .label
		static let placeholderText: String = "화폐"
	}
}
