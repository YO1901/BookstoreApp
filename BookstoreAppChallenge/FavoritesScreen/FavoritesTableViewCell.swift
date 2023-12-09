//
//  FavoritesTableViewCell.swift
//  BookstoreAppChallenge
//
//  Created by Мой Macbook on 08.12.2023.
//

import UIKit
import SnapKit


final class FavoritesTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    static let identifier: String = "FavoritesTableViewCell"
    
    let conteiner = UIView()
    
     let bookImageView: UIImageView = {
        let imageView = UIImageView()
        //imageView.image = UIImage(named: "book")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
     let genreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.numberOfLines = 1
        label.textColor = .white
        //label.text = "Novel"
        return label
    }()
    
     let bookTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textColor = .white
        //label.text = "Tuesday Mooney Talks to Ghosts"
        return label
    }()
    
     let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.numberOfLines = 1
        label.textColor = .white
        //label.text = "Kate Racculia"
        return label
    }()
    
     lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.tintColor = .white
        button.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
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
        conteiner.backgroundColor = .black
        conteiner.layer.cornerRadius = 10
        
        [bookImageView, genreLabel, bookTitleLabel, authorLabel, closeButton].forEach { conteiner.addSubview($0)}
        contentView.addSubview(conteiner)
    }
    
    @objc func closeTapped() {
        printContent("tap")
    }
    
    private func setupLayout() {
        
        conteiner.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.top.equalToSuperview().inset(8)
        }
        
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

extension FavoritesTableViewCell: Configurable {
    
    func update(model: Model) {
        authorLabel.text = model.author
        genreLabel.text = model.genre
        bookTitleLabel.text = model.bookTitle
        
        guard let imageURL = model.bookImage else {
            bookImageView.image = nil
            return
        }
        
        bookImageView.kf.setImage(with: imageURL)
    }

    struct Model {
        var genre: String?
        var bookTitle: String?
        var author: String?
        var bookImage: URL?
    }
    
}
