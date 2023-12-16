//
//  CategoryView.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 16.12.2023.
//

import UIKit

final class CategoryView: UIView {
    
    private let backgroundView = {
        let view = UIImageView()
        view.image = Images.category
        view.contentMode = .scaleToFill
        view.image = Images.category
        return view
    }()
    
    private let label = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = Colors.whitePrimary.light
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        addSubview(backgroundView)
        addSubview(label)
        
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.lessThanOrEqualToSuperview()
        }
        
        layer.cornerRadius = 5
        layer.masksToBounds = true
    }
}


extension CategoryView: Configurable {
    struct Model {
        let name: String
    }
    
    func update(model: Model) {
        label.text = model.name
    }
}
