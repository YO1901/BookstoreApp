//
//  MainViewRouter.swift
//  BookstoreAppChallenge
//
//  Created by Nikita Shirobokov on 09.12.23.
//

import UIKit

final class MainViewRouter {
    
    func makeScreen() -> UIViewController {
        let controller = MainViewController()
        let presenter = MainViewPresenter()
        
        controller.presenter = presenter
        presenter.view = controller
        presenter.router = self
        
        return controller
    }
    
    func navigateToBookDetailScreen(with doc: DocEntity) {
        guard let navigationController = SceneDelegate.shared.navigationController else { return }
        let bookScreen = BookRouter().makeScreen(doc: doc)
        navigationController.pushViewController(bookScreen, animated: true)
    }
    
    func navigateToBookListScreen(with books: [DocEntity], title: String) {
        let bookListRouter = BookListRouter(flow: .seeMore(title: title, books: books))
        let bookListScreen = bookListRouter.makeScreen()
        if let navigationController = SceneDelegate.shared.navigationController {
            navigationController.pushViewController(bookListScreen, animated: true)
        } else {
//            controller?.present(bookListScreen, animated: true, completion: nil)
        }
    }
    
    func navigateToSearchResultsScreen(with books: [DocEntity]) {
            let searchResultsVC = SearchResultsViewController()
            searchResultsVC.configure(with: books)
            // Переход на searchResultsVC, например:
        if let navigationController = SceneDelegate.shared.navigationController {
            navigationController.pushViewController(searchResultsVC, animated: true)
        } else {}
        }
}


