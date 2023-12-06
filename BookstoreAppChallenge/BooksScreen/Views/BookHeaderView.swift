//
//  BookHeader.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 07.12.2023.
//

import UIKit
import Kingfisher

final class BookHeaderView: UIView {
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    private let textStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 8
        sv.distribution = .equalSpacing
        return sv
    }()
    private let authorLabel = UILabel()
    private let categoryLabel = UILabel()
    private let ratingLabel = UILabel()
    private let addToListButton = DefaultButton()
    private let readButton = DefaultButton()
    private let buttonStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 12
        sv.distribution = .equalSpacing
        return sv
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
        [textStack, buttonStack, imageView].forEach { addSubview($0) }
        [authorLabel, categoryLabel, ratingLabel].forEach { textStack.addArrangedSubview($0) }
        [addToListButton, readButton].forEach { buttonStack.addArrangedSubview($0) }
        
        imageView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.4)
            $0.height.equalTo(imageView.snp.width).multipliedBy(1.55).priority(999)
            $0.leading.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
        
        textStack.snp.makeConstraints {
            $0.top.equalTo(imageView)
            $0.leading.equalTo(imageView.snp.trailing).offset(22)
            $0.trailing.equalToSuperview()
        }
        
        buttonStack.snp.makeConstraints {
            $0.bottom.equalTo(imageView)
            $0.trailing.equalToSuperview()
            $0.leading.equalTo(textStack)
        }
        
        [addToListButton, readButton].forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(40)
            }
        }
    }
}

extension BookHeaderView: Configurable {
    struct Model {
        let imageURL: URL?
        let author: NSAttributedString?
        let category: NSAttributedString?
        let rating: NSAttributedString?
        let addToListClosure: () -> Void
        let readClosure: () -> Void
    }
    
    func update(model: Model) {
        authorLabel.attributedText = model.author
        categoryLabel.attributedText = model.category
        ratingLabel.attributedText = model.rating
        
        addToListButton.update(
            model: .init(
                title: "Add to list",
                font: .systemFont(ofSize: 14, weight: .semibold),
                type: .fillGray,
                tapAction: model.addToListClosure
            )
        )
        
        readButton.update(
            model: .init(
                title: "Read",
                font: .systemFont(ofSize: 14, weight: .semibold),
                type: .fill,
                tapAction: model.readClosure
            )
        )
        
        guard let imageURL = model.imageURL else {
            imageView.image = nil
            return
        }
        
        imageView.kf.setImage(with: imageURL)
        
    }
}
