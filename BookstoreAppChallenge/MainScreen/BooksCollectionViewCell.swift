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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Создаем экземпляр UICollectionViewFlowLayout
                let layout = UICollectionViewFlowLayout()
                layout.scrollDirection = .horizontal
                layout.itemSize = CGSize(width: 180, height: 240) // Задаем размер элемента здесь

                // Инициализация и настройка collectionView
                collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
                collectionView.register(BookCollectionViewCell.self, forCellWithReuseIdentifier: "BookCollectionViewCell")

                // Добавляем collectionView в contentView и настраиваем его ограничения
                contentView.addSubview(collectionView)
                collectionView.snp.makeConstraints { make in
                    make.bottom.trailing.top.equalToSuperview()
                    make.leading.equalToSuperview().offset(20)
                }

                // Настройка делегатов
                collectionView.delegate = self
                collectionView.dataSource = self
            }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with models: [MainBookView.Model]) {
           // Сохраните модель, чтобы использовать ее в dataSource методах UICollectionView
        self.bookModels = models
        collectionView.reloadData()
       }
}

// Расширение для UICollectionViewDataSource и UICollectionViewDelegate
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
}



