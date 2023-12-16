//
//  AccountRouter.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 08.12.2023.
//

import UIKit

final class AccountRouter {
    private weak var controller: UIViewController?
    
    func makeScreen() -> UIViewController {
        let controller = AccountViewController()
        let presenter = AccountPresenter()
        
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
    
    func openListsScreen() {
        controller?.present(NavigationController(rootViewController: ListsRouter().makeScreen()), animated: true)
    }
}
