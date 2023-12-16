//
//  CategoriesViewController.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 16.12.2023.
//

import UIKit
import SnapKit

final class CategoriesViewController: ViewController, CategoriesScreenInput {
    
    typealias CategoryCell = CollectionCell<CategoryView>
    
    var presenter: CategoriesPresenter!
    
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        cv.delegate = self
        cv.dataSource = self
        cv.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Categories"
        
        configure()
    }
    
    
    func updateUI() {
        collectionView.reloadData()
    }
    
    private func configure() {
        view.backgroundColor = Colors.Background.lvl1
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        .init {
            sectionIndex, _ in
            
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(100)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(100)), subitems: [item, item])
            group.interItemSpacing = .fixed(20)
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 20
            return section
        }
    }
}

extension CategoriesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        cell.update(with: .init(name: presenter.items[indexPath.row].title))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.items[indexPath.row].didSelectHandler()
    }
}

extension CategoriesViewController {
    struct Category {
        let title: String
        let didSelectHandler: () -> Void
    }
}
