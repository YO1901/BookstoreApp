//
//  MainBookView.swift
//  BookstoreAppChallenge
//
//  Created by Nikita Shirobokov on 09.12.23.
//

import UIKit
import Kingfisher

final class MainBookView: UIView {
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    private let textStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 8
        sv.distribution = .equalSpacing
        return sv
    }()
    
    private let categoryLabel = UILabel()
    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
        setupConstraints()
    }
    
    private func configure() {
        [imageView, textStack].forEach {addSubview($0)}
        
        [categoryLabel, titleLabel, authorLabel].forEach {
            textStack.addArrangedSubview($0)
        }
        
        categoryLabel.font = .systemFont(ofSize: 12)
        titleLabel.font = .boldSystemFont(ofSize: 16)
        authorLabel.font = .systemFont(ofSize: 14)
    }
    private func setupConstraints() {
            // Assuming the imageView is the book cover and should take the full height of the view
            imageView.snp.makeConstraints { make in
                make.leading.top.bottom.equalToSuperview().inset(8) // Adjust inset as needed
                make.width.equalTo(imageView.snp.height) // Assuming a square aspect ratio for the book cover
            }
            
            textStack.snp.makeConstraints { make in
                make.leading.equalTo(imageView.snp.trailing).offset(8)
                make.top.bottom.equalToSuperview().inset(8)
                make.trailing.equalToSuperview().inset(8)
            }
    }
}

extension MainBookView: Configurable {
    
    struct Model {
        let imageURL: URL?
        let category: NSAttributedString?
        let title: NSAttributedString?
        let author: NSAttributedString?
    }
    
    func update(model: Model) {
        authorLabel.attributedText = model.author
        categoryLabel.attributedText = model.category
        titleLabel.attributedText = model.title
        
        guard let imageURL = model.imageURL else {
            imageView.image = nil
            return
        }
        
        imageView.kf.setImage(with: imageURL)
    }
}
