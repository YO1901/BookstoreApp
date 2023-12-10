//
//  DefaultButton.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 06.12.2023.
//

import UIKit

    final class DefaultButton: UIView {
    
    private enum Layout {
        static let cornerRadius: CGFloat = 5
        static let borderWidth: CGFloat = 2
    }
    
    private let button = UIButton(type: .system)
    private var tapAction: (() -> Void)?
    private var needBorder = false {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
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
        
        configureBorder()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        guard traitCollection != previousTraitCollection else {
            return
        }
        
        configureBorder()
    }
    
    private func configure() {
        addSubview(button)
        button.layer.cornerRadius = Layout.cornerRadius
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        button.addTarget(self, action: #selector(tapHandler(_:)), for: .touchUpInside)
    }
    
    private func configureBorder() {
        if needBorder {
            let frame = CGRectInset(button.frame, -Layout.borderWidth, -Layout.borderWidth)
            button.layer.frame = frame
            button.layer.borderColor = Colors.blackPrimary.cgColor
            button.layer.borderWidth = Layout.borderWidth
        } else {
            button.layer.frame = button.frame
            button.layer.borderWidth = .zero
        }
    }
    
    @objc
    private func tapHandler(_ sender: UIButton) {
        tapAction?()
    }
}

extension DefaultButton: Configurable {
    struct Model {
        
        enum ButtonType {
            case fill
            case fillGray
            case stroke
            case onlyText
        }
        
        let title: String
        let font: UIFont
        let type: ButtonType
        let tapAction: () -> Void
        
        init(
            title: String,
            font: UIFont = .systemFont(ofSize: 20),
            type: ButtonType,
            tapAction: @escaping () -> Void
        ) {
            self.title = title
            self.font = font
            self.type = type
            self.tapAction = tapAction
        }
    }
    
    func update(model: Model) {
        tapAction = model.tapAction
        button.setTitle(model.title, for: .normal)
        button.titleLabel?.font = model.font
        switch model.type {
        case .fill:
            button.backgroundColor = Colors.blackPrimary
            needBorder = false
            button.setTitleColor(Colors.whitePrimary, for: .normal)
        case .stroke:
            button.backgroundColor = Colors.whitePrimary
            needBorder = true
            button.setTitleColor(Colors.blackPrimary, for: .normal)
        case .fillGray:
            button.backgroundColor = Colors.grayPrimary
            needBorder = false
            button.setTitleColor(Colors.whitePrimary, for: .normal)
        case .onlyText:
            button.setTitleColor(Colors.blackPrimary, for: .normal)
        }
    }
}
