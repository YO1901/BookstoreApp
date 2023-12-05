//
//  UILabel+Extension.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 06.12.2023.
//

import UIKit

extension UILabel: Configurable {
    struct Model {
        let text: String?
        let textColor: UIColor?
        let numberOfLines: Int
        let textAlignment: NSTextAlignment
        
        init(
            text: String?,
            textColor: UIColor? = Colors.blackPrimary,
            numberOfLines: Int = 0,
            textAlignment: NSTextAlignment = .left
        ) {
            self.text = text
            self.textColor = textColor
            self.numberOfLines = numberOfLines
            self.textAlignment = textAlignment
        }
    }
    
    func update(model: Model) {
        self.text = model.text
        self.textColor = model.textColor
        self.numberOfLines = model.numberOfLines
        self.textAlignment = model.textAlignment
    }
}
