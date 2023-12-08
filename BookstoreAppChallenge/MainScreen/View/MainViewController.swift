//
//  MainViewController.swift
//  BookstoreAppChallenge
//
//  Created by Yerlan Omarov on 04.12.2023.
//

import UIKit
import SnapKit

class MainViewController: ViewController {
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("MainVC", for: .normal)
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
        self.navigationController?.pushViewController(
            BookRouter().makeScreen(
                doc: .init(
                    key: "/works/OL27448W",
                    title: "The Lord ot the Rings",
                    authorName: ["J.R.R. Tolkien"],
                    subject: ["Fiction"],
                    firstPublishYear: 1954,
                    coverI: 9255566,
                    ratingsAverage: 4.1
                )
            ),
            animated: true
        )
    }
}

