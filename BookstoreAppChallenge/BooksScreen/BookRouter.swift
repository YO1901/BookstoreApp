//
//  BookRouter.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 06.12.2023.
//

import UIKit

final class BookRouter {
    
    private weak var controller: UIViewController?
    
    func makeScreen(doc: DocEntity) -> UIViewController {
        let controller = BookViewController()
        let presenter = BookPresenter(doc)
        
        controller.presenter = presenter
        presenter.view = controller
        presenter.router = self
        
        self.controller = controller
        
        return controller
    }
    
    func openListsScreen(selectListClosure: @escaping (String) -> Void) {
        guard let controller else {
            return
        }
        let listsController = NavigationController(rootViewController: ListsRouter().makeScreen(selectListClosure))
        controller.present(listsController, animated: true)
    }
    
    func dissmissPresented() {
        guard let controller else {
            return
        }
        controller.dismiss(animated: true)
    }
}
