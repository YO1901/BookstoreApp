//
//  BooksViewController.swift
//  BookstoreAppChallenge
//
//  Created by Nikita Shirobokov on 06.12.23.
//

import UIKit
import SnapKit

class BooksViewController: UIViewController {
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("BooksVC", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(button)
        setupLayout()
    }
    
    func setupLayout() {
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    @objc func didTapButton() {
        self.navigationController?.pushViewController(FavoritesViewController(), animated: true)
    }
}
