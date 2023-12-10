//
//  MainViewRouter.swift
//  BookstoreAppChallenge
//
//  Created by Nikita Shirobokov on 09.12.23.
//

import UIKit

final class MainViewRouter {
    func makeScreen(doc: DocEntity) -> UIViewController {
        let controller = MainViewController()
        let presenter = MainViewPresenter(doc)
        
        controller.presenter = presenter
        presenter.view = controller
        presenter.router = self
        
        return controller
    }
}
