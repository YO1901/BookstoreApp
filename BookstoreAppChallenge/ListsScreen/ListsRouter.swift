//
//  ListsRouter.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 14.12.2023.
//

import UIKit

final class ListsRouter {
    
    private weak var controller: UIViewController?
    
    func makeScreen(_ selectListClosure: ((String) -> Void)? = nil) -> UIViewController {
        let controller = ListsViewController()
        let presenter = ListsPresenter(selectListClosure)
        controller.presenter = presenter
        presenter.view = controller
        presenter.router = self
        
        self.controller = controller
        
        return controller
    }
    
    func openListScreen(listName: String) {
        guard let controller else { return }
        let vc = NavigationController(rootViewController: BookListRouter(flow: .list(title: listName)).makeScreen())
        if let navController = controller as? UINavigationController {
            navController.pushViewController(vc, animated: true)
        } else {
            controller.present(vc, animated: true)
        }
    }
}
