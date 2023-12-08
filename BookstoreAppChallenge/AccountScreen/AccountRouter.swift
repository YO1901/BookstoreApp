//
//  AccountRouter.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 08.12.2023.
//

import UIKit

final class AccountRouter {
    private var controller: UIViewController?
    
    func makeScreen() -> UIViewController {
        let controller = AccountViewController()
        let presenter = AccountPresenter()
        
        controller.presenter = presenter
        presenter.view = controller
        presenter.router = self
        
        return controller
    }
}
