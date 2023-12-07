//
//  AvatarView.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 08.12.2023.
//

import UIKit

final class AvatarView: UIView {
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.layer.cornerRadius = imageView.bounds.width / 2
    }
    
    private func configure() {
        
        addSubview(imageView)
        
        imageView.image = Images.avatar.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = Colors.blackPrimary
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension AvatarView: Configurable {
    struct Model {
        let image: UIImage?
    }
    
    func update(model: Model) {
        guard let image = model.image else {
            imageView.image = Images.avatar.withRenderingMode(.alwaysTemplate)
            return
        }
        imageView.image = image
    }
}
