//
//  UserDefaultsService.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 06.12.2023.
//

import Foundation

final class UserDefaultsService {
    static let shared = UserDefaultsService()
    
    private init() {
        UserDefaults.standard.register(defaults: [
            "wasOnboardingShow": false
        ])
    }
    
    var wasOnboardingShow: Bool {
        get {
            UserDefaults.standard.bool(forKey: "wasOnboardingShow")
        }
        
        set {
            UserDefaults.standard.setValue(true, forKey: "wasOnboardingShow")
        }
    }
}
