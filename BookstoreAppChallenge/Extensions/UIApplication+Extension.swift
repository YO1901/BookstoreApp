//
//  UIApplication+Extension.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 05.12.2023.
//

import UIKit

extension UIApplication {
    var keyWindow: UIWindow? {
        connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
    }
}
