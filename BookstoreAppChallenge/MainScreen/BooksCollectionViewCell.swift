//
//  BooksCollectionViewCell.swift
//  BookstoreAppChallenge
//
//  Created by Nikita Shirobokov on 11.12.23.
//

import UIKit
import SnapKit

final class BooksCollectionViewCell: UITableViewCell {
    var collectionView: UICollectionView!
    var bookModels: [MainBookView.Model]?
    var onBookSelect: ((DocEntity) -> Void)? // Добавляем обработчик выбора книги
    var books: [DocEntity]?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 180, height: 240)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(BookCollectionViewCell.self, forCellWithReuseIdentifier: "BookCollectionViewCell")
        contentView.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func configure(with models: [MainBookView.Model]) {
        self.bookModels = models
        collectionView.reloadData()
    }
}

extension BooksCollectionViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookModels?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCollectionViewCell", for: indexPath) as? BookCollectionViewCell,
              let model = bookModels?[indexPath.row] else {
            fatalError("Could not dequeue BookCollectionViewCell")
        }
        cell.configure(with: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let book = books?[indexPath.row] {
            onBookSelect?(book)
        }
    }
}




