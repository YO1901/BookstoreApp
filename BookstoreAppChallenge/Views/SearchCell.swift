//
//  SearchCell.swift
//  BookstoreAppChallenge
//
//  Created by Nikita Shirobokov on 17.12.23.
//

import UIKit

final class SearchView: UIView {
    
    var searchAction: ((String) -> Void)?
    
    lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search title/author/ISBN no"
        textField.borderStyle = .roundedRect
        textField.returnKeyType = .search
        textField.delegate = self
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(searchTextField)
        searchTextField.snp.makeConstraints { make in
//            make.leading.equalToSuperview().offset(16)
//            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(8)
//            make.bottom.equalToSuperview().offset(-8)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.center.equalToSuperview()
            make.height.equalTo(60)
        }
        searchTextField.layer.borderWidth = 1.0
        searchTextField.layer.borderColor = Colors.blackPrimary.cgColor
        searchTextField.layer.cornerRadius = 10.0
    }
}

extension SearchView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Dismiss the keyboard
        // Assuming your search action is here:
        if let text = textField.text, !text.isEmpty {
            searchAction?(text)
        }
        return true
    }
}

