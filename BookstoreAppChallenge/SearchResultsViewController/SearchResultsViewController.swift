//
//  SearchResultsViewController.swift
//  BookstoreAppChallenge
//
//  Created by Nikita Shirobokov on 17.12.23.
//

import UIKit
import SnapKit

class SearchResultsViewController: UIViewController {
    var books: [DocEntity] = [] // Данные о книгах, которые нужно отобразить
    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        view.backgroundColor = Colors.whitePrimary
    }

    func configure(with books: [DocEntity]) {
        self.books = books
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 180, height: 240)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 10

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(BookCollectionViewCell.self, forCellWithReuseIdentifier: "BookCollectionViewCell")
        collectionView.backgroundColor = Colors.whitePrimary
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)

        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20))
        }
    }
}

extension SearchResultsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCollectionViewCell", for: indexPath) as? BookCollectionViewCell else {
            fatalError("Could not dequeue BookCollectionViewCell")
        }
        let book = books[indexPath.row]
        let model = MainBookView.Model(imageURL: book.coverURL(), category: NSAttributedString(string: book.subject?.first ?? ""), title: NSAttributedString(string: book.title), author: NSAttributedString(string: book.authorName?.first ?? ""))
        cell.configure(with: model)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Здесь обработайте выбор книги, например:
        // let book = books[indexPath.row]
        // showBookDetail(for: book)
    }
}

