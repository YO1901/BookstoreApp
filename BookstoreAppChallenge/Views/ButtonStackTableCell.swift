//
//  ButtonStackTableCell.swift
//  BookstoreAppChallenge
//
//  Created by Nikita Shirobokov on 13.12.23.
//

import UIKit
import SnapKit

final class ButtonStackTableViewCell<Button1: DefaultButton & Configurable, Button2: DefaultButton & Configurable, Button3: DefaultButton & Configurable>: UITableViewCell {
    
    let button1 = Button1()
    let button2 = Button2()
    let button3 = Button3()
    let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configure()
    }
    
    private func configure() {
//        contentView.addSubview(button)
        stack.addArrangedSubview(button1)
        stack.addArrangedSubview(button2)
        stack.addArrangedSubview(button3)
        contentView.addSubview(stack)
        stack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    func update(modelButton1: DefaultButton.Model, modelButton2: DefaultButton.Model, modelButton3: DefaultButton.Model) {
        button1.update(model: modelButton1)
        button2.update(model: modelButton2)
        button3.update(model: modelButton3)
    }
}
