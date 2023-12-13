//
//  FavoritesRouter.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 12.12.2023.
//

import UIKit

final class FavoritesRouter {
    
    private weak var controller: UIViewController?
    
    func makeScreen(listTitle: String? = nil) -> UIViewController {
        let presenter = FavoritesPresenter(listTitle)
        let controller = FavoritesViewController()
        controller.presenter = presenter
        presenter.view = controller
        presenter.router = self
        
        self.controller = controller
        return controller
    }
    
    func makeWrappedNavigationScreen() -> UIViewController {
        let controller = NavigationController(rootViewController: makeScreen())
        self.controller = controller
        
        return controller
    }
    
    func openBookScreen(doc: DocEntity) {
        if let controller = controller as? UINavigationController {
            controller.pushViewController(
                BookRouter().makeScreen(
                    doc: doc
                ),
                animated: true
            )
        } else {
            controller?.present(
                BookRouter().makeScreen(
                    doc: doc
                ),
                animated: true
            )
        }
    }
}
