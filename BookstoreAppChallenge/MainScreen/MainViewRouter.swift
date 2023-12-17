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
}


