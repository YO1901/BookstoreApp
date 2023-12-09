//
//  AppTabBarController.swift
//  BookstoreAppChallenge
//
//  Created by Nikita Shirobokov on 06.12.23.
//

import UIKit

class AppTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBarController()
    }
    
    private func setupTabBarController() {

        let homeViewController = MainViewController()
        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        
        let categoriesViewController = CategoriesViewController()
        categoriesViewController.tabBarItem = UITabBarItem(title: "Categories", image: UIImage(systemName: "rectangle.grid.2x2"), tag: 1)
        
        let favoritesViewController = FavoritesViewController()
        favoritesViewController.tabBarItem = UITabBarItem(title: "Likes", image: UIImage(systemName: "heart"), tag: 2)
        
        let accountViewController = AccountRouter().makeScreen()
        accountViewController.tabBarItem = UITabBarItem(title: "Account", image: UIImage(systemName: "person.crop.circle"), tag: 3)

        let nav1 = NavigationController(rootViewController: homeViewController)
        let nav2 = NavigationController(rootViewController: categoriesViewController)
        let nav3 = NavigationController(rootViewController: favoritesViewController)
        let nav4 = NavigationController(rootViewController: accountViewController)

        self.viewControllers = [nav1, nav2, nav3, nav4]
        
        favoritesViewController.title = "Likes"

        self.tabBar.tintColor = .red
        self.tabBar.unselectedItemTintColor = .gray
        self.tabBar.backgroundColor = .green
    }
}

