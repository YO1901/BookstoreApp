//
//  NamedTextField.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 08.12.2023.
//

import UIKit

final class NamedTextField: UIView, UITextFieldDelegate {
    
    private let label = UILabel()
    private let textField = UITextField()
    private var didEnterTextClosure: ((String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        
        backgroundColor = Colors.grayLight
        layer.cornerRadius = 5.0
        
        addSubview(textField)
        
        textField.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-13)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(13)
        }
        
        textField.delegate = self
        textField.textAlignment = .center
        textField.returnKeyType = .done
        textField.leftView = label
        textField.leftViewMode = .always
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        didEnterTextClosure?(textField.text ?? "")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension NamedTextField: Configurable {
    struct Model {
        let name: NSAttributedString?
        let textFieldText: String?
        let textFieldFont: UIFont
        let textFieldColor: UIColor
        let didEnterText: ((String) -> Void)?
    }
    
    func update(model: Model) {
        label.attributedText = model.name
        textField.text = model.textFieldText
        textField.font = model.textFieldFont
        textField.textColor = model.textFieldColor
        didEnterTextClosure = model.didEnterText
    }
}
