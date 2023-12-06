//
//  FavoritesViewController.swift
//  BookstoreAppChallenge
//
//  Created by Nikita Shirobokov on 06.12.23.
//

import UIKit
import SnapKit

class FavoritesViewController: UIViewController {
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "FavoritesVC"
        label.textColor = .black
        label.font = .systemFont(ofSize: 30)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = .white
        view.addSubview(label)
        setupLayout()
    }
    
    func setupLayout() {
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
