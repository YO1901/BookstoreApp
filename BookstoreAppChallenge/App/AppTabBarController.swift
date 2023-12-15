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
        
        setupTabBarController()
        setupSelectionIndicatorImage()
    }
    
    private func setupTabBarController() {
//        let homeViewController = MainViewRouter().makeScreen(doc: .init(
//            key: "/works/OL27448W",
//            title: "The Lord ot the Rings",
//            authorName: ["J.R.R. Tolkien"],
//            subject: ["Fiction"],
//            firstPublishYear: 1954,
//            coverI: 9255566,
//            ratingsAverage: 4.1))
        
        let homeViewController = MainViewRouter().makeScreen()
        
        homeViewController.tabBarItem = UITabBarItem(
            title: "Home",
            image: Images.home,
            selectedImage: Images.home.withTintColor(
                Colors.whitePrimary,
                renderingMode: .alwaysOriginal))
        
        let categoriesViewController = CategoriesViewController()
        categoriesViewController.tabBarItem = UITabBarItem(
            title: "Categories", 
            image: Images.categories,
            selectedImage: Images.categories.withTintColor(
                Colors.whitePrimary,
                renderingMode: .alwaysOriginal))
        let favoritesViewController = FavoritesViewController()
        favoritesViewController.tabBarItem = UITabBarItem(
            title: "Likes",
            image: Images.likes,
            selectedImage: Images.likes.withTintColor(
                Colors.whitePrimary,
                renderingMode: .alwaysOriginal))
        
        let accountViewController = AccountRouter().makeScreen()
        accountViewController.tabBarItem = UITabBarItem(
            title: "Account", image: Images.account,
            selectedImage: Images.account.withTintColor(
                Colors.whitePrimary,
                renderingMode: .alwaysOriginal))

        let nav1 = UINavigationController(rootViewController: homeViewController)
        let nav2 = UINavigationController(rootViewController: categoriesViewController)
        let nav3 = UINavigationController(rootViewController: favoritesViewController)
        let nav4 = UINavigationController(rootViewController: accountViewController)

        self.viewControllers = [nav1, nav2, nav3, nav4]

        self.tabBar.tintColor = .black
        self.tabBar.unselectedItemTintColor = Colors.blackPrimary
        self.tabBar.backgroundColor = Colors.grayLight
    }
    
    // OLD
    private func setupSelectionIndicatorImage() {
            guard let numberOfItems = tabBar.items?.count, numberOfItems > 0 else { return }
            let tabBarItemSize = CGSize(width: tabBar.frame.width / CGFloat(numberOfItems), height: tabBar.frame.height)
            let indicatorHeight: CGFloat = 30 // Height of the indicator
            let indicatorWidth: CGFloat = 60 // Width of the indicator - adjust as necessary
            let cornerRadius: CGFloat = indicatorHeight / 2 // Corner radius for rounded corners

            // Create an image with a rounded rectangle selection indicator
            let selectionIndicatorImage = UIGraphicsImageRenderer(size: tabBarItemSize).image { _ in
                let path = UIBezierPath(
                    roundedRect: CGRect(
                        x: (tabBarItemSize.width - indicatorWidth) - 22,
                        y: tabBarItemSize.height - indicatorHeight - 32, // Adjust this to position the indicator right below the icon
                        width: indicatorWidth,
                        height: indicatorHeight),
                    cornerRadius: cornerRadius
                )
                UIColor.black.setFill()
                path.fill()
            }
            
            // Set a resizable image with the indicator as the selection indicator
            tabBar.selectionIndicatorImage = selectionIndicatorImage.resizableImage(withCapInsets: .zero)
        }

}

