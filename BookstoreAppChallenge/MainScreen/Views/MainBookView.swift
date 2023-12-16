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
    
    private let colorImage: UIImageView = {
        let cv = UIImageView()
        cv.contentMode = .scaleAspectFit
        cv.backgroundColor = .black
        cv.clipsToBounds = true
        return cv
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

        addSubview(imageView)
        addSubview(colorImage)
        addSubview(textStack)
        
        [categoryLabel, titleLabel, authorLabel].forEach {
            textStack.addArrangedSubview($0)
            $0.textColor = .whitePrimary
        }
        
        categoryLabel.font = .systemFont(ofSize: 12)
//        categoryLabel.textColor = .whitePrimary
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.numberOfLines = 0
        authorLabel.font = .systemFont(ofSize: 14)
    }
    private func setupConstraints() {
            // Assuming the imageView is the book cover and should take the full height of the view
            imageView.snp.makeConstraints { make in
                make.top.equalTo(12) // Adjust inset as needed
                make.width.equalTo(91)
                make.height.equalTo(134)
                make.centerX.equalToSuperview()
            }
            
            textStack.snp.makeConstraints { make in
                make.top.equalTo(imageView.snp.bottom).inset(-10)
//                make.width.equalToSuperview().inset(3)
                make.height.width.equalTo(colorImage).inset(8)
                make.centerX.equalTo(colorImage)
            }
        
        colorImage.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(imageView).multipliedBy(0.65)
            make.top.equalTo(imageView.snp.bottom)
        }
        colorImage.clipsToBounds = false
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
