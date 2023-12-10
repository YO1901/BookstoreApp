//
//  MainViewController.swift
//  BookstoreAppChallenge
//
//  Created by Yerlan Omarov on 04.12.2023.
//

import UIKit
import SnapKit

final class MainViewController: UIViewController {
    
    typealias BookCell = CollectionCell<MainBookView>
    typealias LabelButtonCell = LabelButtonTableViewCell<UILabel, DefaultButton>
    
    var presenter: MainViewPresenterProtocol!
    
    private var items = [ViewModel.Item]()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(LabelButtonCell.self, forCellReuseIdentifier: "labelButtonCell")
        tv.register(SpaceCell.self, forCellReuseIdentifier: "spaceCell")
        tv.register(BookCell.self, forCellReuseIdentifier: "bookCell")
        tv.backgroundColor = .clear
        tv.rowHeight = UITableView.automaticDimension
        tv.delegate = self
        tv.dataSource = self
        tv.showsVerticalScrollIndicator = false
        tv.separatorStyle = .none
        tv.delaysContentTouches = false
        return tv
    }()
    
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView()
        cv.register(BookCell.self, forCellWithReuseIdentifier: "bookCell")
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.activate()
        view.backgroundColor = .white
        // Регистрация кастомной ячейки для UICollectionView в UITableView
        tableView.register(BooksCollectionViewCell.self, forCellReuseIdentifier: "BooksCollectionViewCell")
        view.addSubview(tableView)
                tableView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
    }
    
    private func makeCollectionCell(categories: String?, title: String?, author: String?) -> NSAttributedString? {
        guard let categories,
              let title,
              let author else {
            return nil
        }
        let result = NSMutableAttributedString()
        let category = NSAttributedString(string: "\(categories) : ", attributes: [.font: UIFont.systemFont(ofSize: 11, weight: .regular), .foregroundColor: Colors.whitePrimary])
        let name = NSAttributedString(string: title, attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .semibold), .foregroundColor: Colors.whitePrimary])
        let creator = NSAttributedString(string: author, attributes: [.font: UIFont.systemFont(ofSize: 11, weight: .semibold), .foregroundColor: Colors.whitePrimary])
        result.append(category)
        result.append(name)
        result.append(creator)
        return result
    }
    
    @objc func didTapButton() {
        self.navigationController?.pushViewController(
            BookRouter().makeScreen(
                doc: .init(
                    key: "/works/OL27448W",
                    title: "The Lord ot the Rings",
                    authorName: ["J.R.R. Tolkien"],
                    subject: ["Fiction"],
                    firstPublishYear: 1954,
                    coverI: 9255566,
                    ratingsAverage: 4.1
                )
            ),
            animated: true
        )
    }
}

extension MainViewController: MainViewProtocol {
    func update(with model: ViewModel) {
        items.removeAll()
    }
}


extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        
        switch item {
        case .wishTitle(item: let item):
            let cell = tableView.dequeueReusableCell(withIdentifier: "labelButtonCell", for: indexPath) as! LabelButtonCell
            cell.update(modelView: item.modelView, modelButton: item.modelButton)
            return cell
        case .topBooksTitle(item: let item):
            let cell = tableView.dequeueReusableCell(withIdentifier: "labelButtonCell", for: indexPath) as! LabelButtonCell
            cell.update(modelView: item.modelView, modelButton: item.modelButton)
            return cell
        case .sortingButtons(item: let item):
            let cell = tableView.dequeueReusableCell(withIdentifier: "labelButtonCell", for: indexPath) as! LabelButtonCell
            cell.update(modelView: item.modelView, modelButton: item.modelButton)
            return cell
        case .topBooks(item: let item):
            let cell = tableView.dequeueReusableCell(withIdentifier: "BooksCollectionViewCell", for: indexPath) as! BooksCollectionViewCell
//            cell.update(with: item)
            return cell
        case .recentTitle(item: let item):
            let cell = tableView.dequeueReusableCell(withIdentifier: "labelButtonCell", for: indexPath) as! LabelButtonCell
            cell.update(modelView: item.modelView, modelButton: item.modelButton)
            return cell
        case .recentBooks(item: let item):
            let cell = tableView.dequeueReusableCell(withIdentifier: "BooksCollectionViewCell", for: indexPath) as! BooksCollectionViewCell
//            cell.update(with: item)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bookCell", for: indexPath) as? BookCell else {
            fatalError("Could not dequeue BookCollectionViewCell")
        }
//        cell.update(with: <#T##MainBookView.Model#>)
        return cell
    }
}

 

extension MainViewController {
    struct ViewModel {
        
        struct HeaderItem {
        let imageURL: URL?
        let author: String?
        let category: String?
        let rating: String?
        let seeMoreClosure: (() -> Void)
        let readClosure: (() -> Void)
    }
        
        enum Item {
            case wishTitle(modelView: UILabel.Model, modelButton: DefaultButton.Model)
            case topBooksTitle(modelView: UILabel.Model, modelButton: DefaultButton.Model)
            case sortingButtons(modelView: UILabel.Model, modelButton: DefaultButton.Model)
            case topBooks(item: MainBookView.Model)
            case recentTitle(modelView: UILabel.Model, modelButton: DefaultButton.Model)
            case recentBooks(item: MainBookView.Model)
        }
        
//        let books: [Book]
//        let button: DefaultButton.Model
    }
}
