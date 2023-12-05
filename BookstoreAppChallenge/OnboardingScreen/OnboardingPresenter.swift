//
//  OnboardingPresenter.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 05.12.2023.
//

import Foundation

final class OnboardingPresenter: OnboardingOutput {
    
    typealias ViewModel = OnboardingViewController.ViewModel
    
    var router: OnboardingRouter?
    weak var view: OnboardingInput?
    
    func activate() {
        
        UserDefaultsService.shared.wasOnboardingShow = true
        
        view?.updateUI(
            with: .init(
                items: [
                    .init(text: "Read books anytime at anywhere!"),
                    .init(text: "Find the perfect book for and discover a new one that interest you"),
                    .init(text: "Save your favorite books")
                ],
                button: .init(
                    title: "Get Started",
                    fontSize: 20,
                    type: .fill,
                    tapAction: {
                        [weak self] in
                        
                        self?.router?.openMainScreen()
                    }
                )
            )
        )
    }
}
