//
//  CategoryView.swift
//  BookstoreAppChallenge
//
//  Created by Victor Rubenko on 16.12.2023.
//

import UIKit

final class CategoryView: UIView {
    
    private let backgroundView = {
        let view = UIImageView()
        view.image = Images.category
        view.contentMode = .scaleToFill
        return view
    }()
    
    private let gradientView = {
        let view = GradientView()
        view.startPoint = .init(x: 0.5, y: 0)
        view.startPoint = .init(x: 0.5, y: 1)
        view.colors = [Colors.blackPrimary.light, .clear]
        return view
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
        addSubview(gradientView)
        
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        gradientView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
