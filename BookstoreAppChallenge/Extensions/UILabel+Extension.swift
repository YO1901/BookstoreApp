//
//  UILabel+Extension.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 06.12.2023.
//

import UIKit

extension UILabel: Configurable {
    struct Model {
        let text: NSAttributedString
        let numberOfLines: Int
        let textAlignment: NSTextAlignment
        
        init(
            text: NSAttributedString,
            numberOfLines: Int,
            textAlignment: NSTextAlignment
        ) {
            self.text = text
            self.numberOfLines = numberOfLines
            self.textAlignment = textAlignment
        }
        init(
            text: String,
            textFont: UIFont = .systemFont(ofSize: 15),
            textColor: UIColor = Colors.blackPrimary,
            numberOfLines: Int = 0,
            textAlignment: NSTextAlignment = .left
        ) {
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttributes(
                [
                    .font: textFont,
                    .foregroundColor: textColor
                ],
                range: .init(location: 0, length: attributedText.length)
            )
            self.text = attributedText
            self.numberOfLines = numberOfLines
            self.textAlignment = textAlignment
        }
    }
    
    func update(model: Model) {
        self.attributedText = model.text
        self.numberOfLines = model.numberOfLines
        self.textAlignment = model.textAlignment
    }
}
