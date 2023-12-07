//
//  BookRouter.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 06.12.2023.
//

import UIKit

final class BookRouter {
    func makeScreen(doc: DocEntity) -> UIViewController {
        let controller = BookViewController()
        let presenter = BookPresenter(doc)
        
        controller.presenter = presenter
        presenter.view = controller
        presenter.router = self
        
        return controller
    }
}
