//
//  OnboardingProtocols.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 05.12.2023.
//

import Foundation

protocol OnboardingInput: AnyObject {
    func updateUI(with model: OnboardingViewController.ViewModel)
}

protocol OnboardingOutput: AnyObject {
    func activate()
}
