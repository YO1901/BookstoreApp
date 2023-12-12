//
//  UserInterfaceStyleService.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 13.12.2023.
//

import UIKit
import Combine

final class UserInterfaceStyleService {
    static let shared = UserInterfaceStyleService()
    
    @Published private(set) var userInterfaceStyle: UIUserInterfaceStyle
    
    private init() {
        guard let userInterfaceStyle = UserDefaultsService.shared.userInterfaceStyle else {
            userInterfaceStyle = .unspecified
            return
        }
        self.userInterfaceStyle = UIUserInterfaceStyle.fromString(userInterfaceStyle)
    }
    
    func changeStyle() {
        let style: UIUserInterfaceStyle
        switch userInterfaceStyle {
        case .light:
            style = .dark
        case .dark:
            style = .unspecified
        default:
            style = .light
        }
        userInterfaceStyle = style
        UserDefaultsService.shared.userInterfaceStyle = style.string
    }
}

extension UIUserInterfaceStyle {
    var string: String {
        switch self {
        case .dark:
            return "dark"
        case .light:
            return "light"
        default:
            return "unknown"
        }
    }
    
    static func fromString(_ value: String) -> Self {
        if value == Self.dark.string {
            return .dark
        }
        if value == Self.light.string {
            return .light
        }
        return .unspecified
    }
}
