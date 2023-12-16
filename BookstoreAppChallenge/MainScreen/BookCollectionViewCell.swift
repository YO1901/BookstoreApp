//
//  BookCollectionViewCell.swift
//  BookstoreAppChallenge
//
//  Created by Nikita Shirobokov on 11.12.23.
//

import UIKit
import SnapKit

final class BookCollectionViewCell: UICollectionViewCell {
    
    private let mainBookView = MainBookView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(mainBookView)
        contentView.backgroundColor = .gray
        contentView.layer.cornerRadius = 10
        mainBookView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: MainBookView.Model) {
        mainBookView.update(model: model)
    }
}

