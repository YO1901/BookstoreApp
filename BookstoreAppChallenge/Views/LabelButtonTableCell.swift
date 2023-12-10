//
//  LabelButtonTableCell.swift
//  BookstoreAppChallenge
//
//  Created by Nikita Shirobokov on 11.12.23.
//

import UIKit
import SnapKit

final class LabelButtonTableViewCell<View: UIView & Configurable, Button: DefaultButton & Configurable>: UITableViewCell {
    
    let view = View()
    let button = Button()
//    let stack: UIStackView = {
//        let stack = UIStackView()
//        stack.axis = .horizontal
//        return stack
//    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configure()
    }
    
    private func configure() {
        contentView.addSubview(view)
        contentView.addSubview(button)
//        view.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
    }
    func update(modelView: View.Model, modelButton: DefaultButton.Model) {
        view.update(model: modelView)
        button.update(model: modelButton)
    }
}
