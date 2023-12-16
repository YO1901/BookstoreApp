//
//  CategoriesRouter.swift
//  BookstoreAppChallenge
//
//  Created by Victor Rubenko on 16.12.2023.
//

import UIKit

final class CategoriesRouter {
    private weak var controller: UIViewController?
    
    func makeScreen() -> UIViewController {
        let presenter = CategoriesPresenter()
        let controller = CategoriesViewController()
        controller.presenter = presenter
        presenter.view = controller
        presenter.router = self
        
        self.controller = controller
        
        return controller
    }
    
    func openListBookScreen(_ category: SubjectRequest.Subject) {
        let vc = BookListRouter(flow: .category(category: category)).makeScreen()
        if let navController = controller?.navigationController {
            navController.pushViewController(vc, animated: true)
        } else {
            controller?.present(vc, animated: true)
        }
    }
    
    func makeWrappedNavigationScreen() -> UIViewController {
        let controller = NavigationController(rootViewController: makeScreen())
        self.controller = controller
        return controller
    }
}
