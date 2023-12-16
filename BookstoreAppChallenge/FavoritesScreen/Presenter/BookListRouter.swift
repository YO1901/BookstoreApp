//
//  BookListRouter.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 12.12.2023.
//

import UIKit

final class BookListRouter {
    
    enum Flow {
        case likes
        case list(title: String)
        case seeMore(title: String, books: [DocEntity])
        case category(category: SubjectRequest.Subject)
    }
    
    private let flow: Flow
    private weak var controller: UIViewController?
    
    init(flow: Flow) {
        self.flow = flow
    }
    
    func makeScreen() -> UIViewController {
        let presenter = BookListPresenter(flow)
        let controller = BookListViewController()
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
