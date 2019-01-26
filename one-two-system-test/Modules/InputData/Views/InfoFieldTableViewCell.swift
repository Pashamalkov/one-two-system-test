//
//  InfoFieldTableViewCell.swift
//  one-two-system-test
//
//  Created by Павел on 25/01/2019.
//  Copyright © 2019 Павел. All rights reserved.
//

import Foundation
import UIKit

extension InfoFieldTableViewCell {
    enum InfoFieldType {
        case empty
        case fill
    }
}

class InfoFieldTableViewCell: UITableViewCell {
    
    private var textField = UITextField()
    private var cellNameLabel = UILabel()
//    var type: InfoFieldsTableView.InfoFieldType = .name {
//        didSet {
//            changeTypeDependOnText()
//        }
//    }
    var fieldId: Int = 0
    
    var title: String {
        set {
            textField.attributedText = NSAttributedString(string: newValue, attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                NSAttributedString.Key.kern: 0.2,
                NSAttributedString.Key.foregroundColor: titleColor
                ])
            changeTypeDependOnText()
        }
        get {
            return textField.text ?? ""
        }
    }
    
    var isEnabled: Bool = true {
        didSet {
            title = textField.text ?? ""
        }
    }
    
    var textPosition: UITextPosition?
    
    private var titleColor: UIColor {
        if isEnabled {
            return .blackColor
        } else {
            return .grayColor
        }
    }
    
    var cellName: String = "" {
        didSet {
            changeTypeDependOnText()
        }
    }
    
    var textFieldShouldBeginEditingCallback: ((Int) -> Void)?
    var textFieldDidChangeCallback: ((Int, String) -> Void)?
    var textFieldShouldReturnCallback: ((Int) -> Bool)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        createUI()
        setConstraints()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createUI() {
        contentView.addSubview(cellNameLabel)
        
        contentView.addSubview(textField)
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField.delegate = self
        textField.autocorrectionType = .no
        textField.returnKeyType = .next
        textField.rightView = UIView.init(frame: CGRect.init(x: 0, y: textField.frame.maxY-90, width: 90, height: 24))
        textField.rightViewMode = .always
        textField.textColor = UIColor.black
        cellNameLabel.textColor = UIColor.lightGray
        setType(.empty)
        setNeedsUpdateConstraints()
    }
    
    private func setType(_ type: InfoFieldType) {
        switch type {
        case .fill:
            cellNameLabel.attributedText = NSAttributedString(string: cellName, attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
                NSAttributedString.Key.kern: 0.2,
                NSAttributedString.Key.foregroundColor: UIColor.grayColor
                ])
        case .empty:
            cellNameLabel.text = ""
            textField.attributedPlaceholder = NSAttributedString(string: cellName, attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                NSAttributedString.Key.kern: 0.2,
                NSAttributedString.Key.foregroundColor: UIColor.grayColor
                ])
        }
    }
    
    private func changeTypeDependOnText() {
        if textField.text?.isEmpty ?? true {
            setType(.empty)
        } else {
            setType(.fill)
        }
    }
    
    func makeFirstResponder() {
        textField.becomeFirstResponder()
    }
    
    private func setConstraints() {
        cellNameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalTo(-11)
            make.top.equalToSuperview().offset(14)
            make.height.equalTo(16)
        }
        textField.snp.makeConstraints { make in
            make.left.equalTo(cellNameLabel)
            make.right.equalToSuperview()
            make.top.equalTo(cellNameLabel.snp.bottom).offset(7)
            make.height.equalTo(24)
            make.bottom.equalToSuperview().inset(13)
        }
    }
}

// MARK: TextFieldDelegate

extension InfoFieldTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if !isEnabled {
            return false
        }
        changeTypeDependOnText()
        textFieldShouldBeginEditingCallback?(fieldId)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        changeTypeDependOnText()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let replacementString = string
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        if (replacementString == " " && text.isEmpty) || newLength > 50 {
            return false
        }
        
        let set = NSCharacterSet.decimalDigits.union(NSCharacterSet.whitespaces).union(CharacterSet.init(charactersIn: "."))
        if replacementString.rangeOfCharacter(from: set) == nil, !replacementString.isEmpty {
            return false
        }
        
        if let selectedRange = textField.selectedTextRange {
            self.textPosition = textField.position(from: selectedRange.start, offset: replacementString.isEmpty ? -1 : replacementString.count)
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return textFieldShouldReturnCallback?(fieldId) ?? true
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        title = textField.text ?? ""
        textFieldDidChangeCallback?(fieldId, textField.text ?? "")
        
        if let newPosition = textPosition {
            textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
        }
    }
}

//class CustomInsetsTextField: UITextField {
//    var inset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    var placeholderInset: UIEdgeInsets = UIEdgeInsets(top: 3.5, left: 0, bottom: 0, right: 0)
//
////    override func textRect(forBounds bounds: CGRect) -> CGRect {
////        return bounds.UIEdgeInsetsInsetRect(by: inset)
////    }
////
////    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
////        return UIEdgeInsetsInsetRect(by: placeholderInset)
////    }
//}
