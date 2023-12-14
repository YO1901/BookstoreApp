//
//  TableCell.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 06.12.2023.
//

import UIKit
import SnapKit

final class TableCell<View>: UITableViewCell where View: UIView & Configurable {
    private let view = View()
    
    private var didSelectHandler: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configure()
    }
    
    private func configure() {
        contentView.addSubview(view)
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(didSelect))
        tapGR.cancelsTouchesInView = false
        contentView.addGestureRecognizer(tapGR)
    }
    
    @objc
    private func didSelect() {
        didSelectHandler?()
    }
    
    func update(with model: View.Model, height: CGFloat? = nil, didSelectHandler: (() -> Void)? = nil) {
        view.update(model: model)
        self.didSelectHandler = didSelectHandler
        
        if let height {
            view.snp.makeConstraints {
                $0.height.equalTo(height)
            }
        }
    }
}
