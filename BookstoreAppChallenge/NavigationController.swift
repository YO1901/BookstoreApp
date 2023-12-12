//
//  NavigationController.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 09.12.2023.
//

import UIKit
import Combine

final class NavigationController: UINavigationController {
    
    private var cancellable = [AnyCancellable]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        UserInterfaceStyleService.shared.$userInterfaceStyle.sink {
            [weak self] style in
            
            self?.overrideUserInterfaceStyle = style
        }.store(in: &cancellable)
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
