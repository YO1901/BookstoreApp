//
//  SceneDelegate.swift
//  BookstoreAppChallenge
//
//  Created by Yerlan Omarov on 04.12.2023.
//

import UIKit
import NetworkService

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    static var shared: SceneDelegate {
            return UIApplication.shared.connectedScenes
                .first!.delegate as! SceneDelegate
        }

        var navigationController: UINavigationController? {
            if let tabBarController = window?.rootViewController as? UITabBarController {
                return tabBarController.selectedViewController as? UINavigationController
            }
            return window?.rootViewController as? UINavigationController
        }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UserDefaultsService.shared.wasOnboardingShow ?  AppTabBarController() : OnboardingRouter().makeScreen()
        self.window = window
        window.makeKeyAndVisible()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        CoreDataService.shared.saveContext()
    }
}
