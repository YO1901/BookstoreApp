//
//  ViewController.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 09.12.2023.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    private var cancellables = [AnyCancellable]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: nil,
            action: nil
        )
        
        overrideUserInterfaceStyle = UserInterfaceStyleService.shared.userInterfaceStyle
        UserInterfaceStyleService.shared.$userInterfaceStyle.sink {
            [weak self] style in
            
            self?.overrideUserInterfaceStyle = style
        }.store(in: &cancellables)

    }
}
