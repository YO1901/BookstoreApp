//
//  AppTabBarController.swift
//  BookstoreAppChallenge
//
//  Created by Nikita Shirobokov on 06.12.23.
//

import UIKit

class AppTabBarController: UITabBarController {
    
    private let selectionIndicatorImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setValue(CustomTabBar(), forKey: "tabBar")
        
        setupTabBarController()
        setupSelectionIndicatorImage()
    }
    
    private func setupTabBarController() {
        let homeViewController = MainViewRouter().makeScreen()
        
        homeViewController.tabBarItem = UITabBarItem(
            title: "Home",
            image: Images.home,
            selectedImage: Images.home.withTintColor(
                Colors.whitePrimary,
                renderingMode: .alwaysOriginal))
        
        let categoriesViewController = CategoriesRouter().makeWrappedNavigationScreen()
        categoriesViewController.tabBarItem = UITabBarItem(
            title: "Categories", 
            image: Images.categories,
            selectedImage: Images.categories.withTintColor(
                Colors.whitePrimary,
                renderingMode: .alwaysOriginal))
        let favoritesViewController = BookListRouter(flow: .likes).makeWrappedNavigationScreen()
        favoritesViewController.tabBarItem = UITabBarItem(
            title: "Likes",
            image: Images.likes,
            selectedImage: Images.likes.withTintColor(
                Colors.whitePrimary,
                renderingMode: .alwaysOriginal))
        
        let accountViewController = AccountRouter().makeWrappedNavigationScreen()
        accountViewController.tabBarItem = UITabBarItem(
            title: "Account", image: Images.account,
            selectedImage: Images.account.withTintColor(
                Colors.whitePrimary,
                renderingMode: .alwaysOriginal))

        let nav1 = NavigationController(rootViewController: homeViewController)

        self.viewControllers = [nav1, categoriesViewController, favoritesViewController, accountViewController]
        
        favoritesViewController.title = "Likes"

        self.tabBar.tintColor = .black
        self.tabBar.unselectedItemTintColor = Colors.blackPrimary
        self.tabBar.backgroundColor = Colors.grayLight
    }
    
    // OLD
    private func setupSelectionIndicatorImage() {
        guard let numberOfItems = tabBar.items?.count, numberOfItems > 0 else { return }
        
        let tabBarItemSize = CGSize(width: tabBar.frame.width / CGFloat(numberOfItems), height: tabBar.frame.height)
        let indicatorHeight: CGFloat = 32 // Высота индикатора
        let indicatorWidth: CGFloat = 64 // Ширина индикатора
        let cornerRadius: CGFloat = 16 // Радиус скругления

        let selectionIndicatorImage = UIGraphicsImageRenderer(size: tabBarItemSize).image { _ in
            let path = UIBezierPath(
                roundedRect: CGRect(
                    x: (tabBarItemSize.width - indicatorWidth) / 2, // Центрирование по горизонтали
                    y: tabBarItemSize.height - indicatorHeight - 50, // Высота tabBar - высота индикатора - отступ снизу
                    width: indicatorWidth,
                    height: indicatorHeight),
                cornerRadius: cornerRadius
            )
            UIColor.black.setFill()
            path.fill()
        }
        
        tabBar.selectionIndicatorImage = selectionIndicatorImage.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: indicatorWidth / 2, bottom: 0, right: indicatorWidth / 2))
    }
}

