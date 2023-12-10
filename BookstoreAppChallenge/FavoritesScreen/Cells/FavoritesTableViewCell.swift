//
//  FavoritesTableViewCell.swift
//  BookstoreAppChallenge
//
//  Created by Мой Macbook on 07.12.2023.
//

import UIKit
import SnapKit

final class FavoritesTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    static let identifier: String = "FavoritesTableViewCell"
    
    private let bookImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "book")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.numberOfLines = 1
        label.textColor = .white
        label.text = "Novel"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bookTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textColor = .white
        label.text = "Tuesday Mooney Talks to Ghosts"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.numberOfLines = 1
        label.textColor = .white
        label.text = "Kate Racculia"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.tintColor = .white
        button.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functions
    
    private func setupViews() {
        backgroundColor = .black
        layer.cornerRadius = 10
        
        [bookImageView, genreLabel, bookTitleLabel, authorLabel, closeButton].forEach { addSubview($0)
        }
    }
    
    @objc func closeTapped() {
        printContent("tap")
    }
    
    private func setupLayout() {
        
        bookImageView.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.width.equalTo(100)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(15)
            make.right.equalTo(-15)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        
        genreLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalTo(bookImageView.snp.right).offset(15)
            make.width.equalTo(130)
        }
        
        bookTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(genreLabel.snp.bottom).offset(5)
            make.left.equalTo(bookImageView.snp.right).offset(15)
            make.width.equalTo(130)
        }
        
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(bookTitleLabel.snp.bottom).offset(5)
            make.left.equalTo(bookImageView.snp.right).offset(15)
            make.width.equalTo(130)
        }
    }
}


