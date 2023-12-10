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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 100) // Адаптируйте размер под ваш дизайн
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(BookCollectionViewCell.self, forCellWithReuseIdentifier: "BookCollectionViewCell")
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// Расширение для UICollectionViewDataSource и UICollectionViewDelegate
extension BooksCollectionViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Возвращаем количество элементов, которое нужно отобразить в вашей коллекции
        return 2 // Для примера, в каждой строке будут 2 книги
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCollectionViewCell", for: indexPath) as? BookCollectionViewCell else {
            fatalError("Could not dequeue BookCollectionViewCell")
        }
        // Настройка cell
        return cell
    }
}



