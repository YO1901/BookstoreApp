//
//  NavigationController.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 09.12.2023.
//

import UIKit

final class NavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    private func configure() {
        navigationBar.tintColor = Colors.blackPrimary
        navigationBar.titleTextAttributes = [
            .foregroundColor: Colors.blackPrimary,
            .font: UIFont.systemFont(ofSize: 16, weight: .semibold)
        ]
        navigationBar.backIndicatorImage = Images.arrowLeft.withRenderingMode(.alwaysTemplate)
        navigationBar.backIndicatorTransitionMaskImage = Images.arrowLeft.withRenderingMode(.alwaysTemplate)
    }
}
