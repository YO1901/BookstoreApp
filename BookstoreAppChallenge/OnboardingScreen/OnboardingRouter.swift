//
//  OnboardingRouter.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 05.12.2023.
//

import UIKit

final class OnboardingRouter {
    
    weak var controller: OnboardingViewController?
    
    func makeScreen() -> UIViewController {
        let controller = OnboardingViewController()
        let presenter = OnboardingPresenter()
        controller.presenter = presenter
        presenter.view = controller
        presenter.router = self
        
        self.controller = controller
        return controller
    }
    
    func openMainScreen() {
        UIApplication.shared.keyWindow?.rootViewController = MainViewController()
    }
}
