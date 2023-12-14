//
//  ListButton.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 13.12.2023.
//

import UIKit

final class ListButton: UIView {
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        button.layer.cornerRadius = 4
        return button
    }()
    
    private var didTapClosure: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        addSubview(button)
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc
    private func didTap() {
        didTapClosure?()
    }
}

extension ListButton: Configurable {
    struct Model {
        let title: String
        let image: UIImage?
        let didTapClosure: () -> Void
    }
    
    func update(model: Model) {
        var configuration = UIButton.Configuration.filled()
        var container = AttributeContainer()
        container.font = .systemFont(ofSize: 16)
        container.foregroundColor = Colors.blackPrimary.light
        configuration.attributedTitle = AttributedString(model.title, attributes: container)
        configuration.imagePlacement = .trailing
        configuration.image = model.image?.withRenderingMode(.alwaysTemplate)
        configuration.baseForegroundColor = Colors.blackPrimary.light
        configuration.baseBackgroundColor = Colors.grayLight
        button.configuration = configuration
        button.contentHorizontalAlignment = .fill
        
        didTapClosure = model.didTapClosure
    }
}
