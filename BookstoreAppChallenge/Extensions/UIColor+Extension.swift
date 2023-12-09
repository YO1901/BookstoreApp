//
//  UIColor+Extension.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 09.12.2023.
//

import UIKit

extension UIColor {
    var dark: UIColor  { resolvedColor(with: .init(userInterfaceStyle: .dark))  }
    var light: UIColor { resolvedColor(with: .init(userInterfaceStyle: .light)) }
}
