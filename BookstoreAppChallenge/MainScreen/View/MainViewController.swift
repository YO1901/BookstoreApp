//
//  MainViewController.swift
//  BookstoreAppChallenge
//
//  Created by Yerlan Omarov on 04.12.2023.
//

import UIKit
import SnapKit

final class MainViewController: UIViewController {
    
    private enum Titles {
        static let happyTitle = "Happy Reading!"
        static let topBooksTitle = "Top Books"
        static let recentTitle = "Recent Books"
        static let seeMoreBtn = "see more"
        static let thisWeekBtn = "This Week"
        static let thisMonthBtn = "This Month"
        static let thisYearBtn = "This Year"
    }
    
    typealias BookCell = CollectionCell<MainBookView>
    typealias LabelButtonCell = LabelButtonTableViewCell<UILabel, DefaultButton>
    typealias ButtonStackCell = ButtonStackTableViewCell<DefaultButton, DefaultButton, DefaultButton>
    
    var presenter: MainViewPresenterProtocol!
    
    private var items = [ViewModel.Item]()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(LabelButtonCell.self, forCellReuseIdentifier: "labelButtonCell")
        tv.register(SpaceCell.self, forCellReuseIdentifier: "spaceCell")
//        tv.register(BookCell.self, forCellReuseIdentifier: "bookCell")
        tv.register(ButtonStackCell.self, forCellReuseIdentifier: "buttonStackCell")
//        tv.register(BookCollectionViewCell.self, forCellReuseIdentifier: "bookCollectionCell")
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
                    make.bottom.leading.trailing.equalToSuperview()
                    make.top.equalToSuperview().inset(70)
                }
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            // To hide the navigation bar when the view is about to appear
            self.navigationController?.setNavigationBarHidden(true, animated: animated)
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            // If you want to show the navigation bar on other screens when leaving this screen
            self.navigationController?.setNavigationBarHidden(false, animated: animated)
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
    private func makeColonText(text: String?) -> NSAttributedString? {
        guard let text else {
            return nil
        }
        let result = NSMutableAttributedString()
        let title = NSAttributedString(string: text, attributes: [.foregroundColor: Colors.whitePrimary])
        result.append(title)
        return result
    }
}

extension MainViewController: MainViewProtocol {
    func update(with model: ViewModel) {

        items.removeAll()
        
        items.append(.wishTitle(
            modelView: .init(text: Titles.happyTitle, textFont: .systemFont(ofSize: 16)),
            modelButton: .init(type: .search, tapAction: didTapButton)))
        items.append(.space(item: .init(height: 15)))
        items.append(.topBooksTitle(
            modelView: .init(text: Titles.topBooksTitle, textFont: .systemFont(ofSize: 20)),
            modelButton: .init(title: Titles.seeMoreBtn, font: .systemFont(ofSize: 16), type: .onlyText, tapAction: didTapButton)))
        items.append(.sortingButtons(modelButton1: .init(title: Titles.thisWeekBtn, font: .systemFont(ofSize: 16), type: .sorting, tapAction: didTapButton), modelButton2: .init(title: Titles.thisMonthBtn, font: .systemFont(ofSize: 16), type: .sorting, tapAction: didTapButton), modelButton3: .init(title: Titles.thisYearBtn, font: .systemFont(ofSize: 16), type: .sorting, tapAction: didTapButton)))
        items.append(.topBooks(item: .init(imageURL: model.topBooks.imageURL, category: makeColonText(text: model.topBooks.category), title: makeColonText(text: model.topBooks.title), author: makeColonText(text: model.topBooks.author))))
        items.append(.recentTitle(
            modelView: .init(text: Titles.recentTitle, textFont: .systemFont(ofSize: 20)),
            modelButton: .init(title: Titles.seeMoreBtn, font: .systemFont(ofSize: 16), type: .onlyText, tapAction: didTapButton)))
        items.append(.recentBooks(item: .init(imageURL: model.recentBooks.imageURL, category: makeColonText(text: model.recentBooks.category), title: makeColonText(text: model.recentBooks.title), author: makeColonText(text: model.recentBooks.author))))
        
        tableView.reloadData()
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
        case .space(item: let item):
            let cell = tableView.dequeueReusableCell(withIdentifier: "spaceCell", for: indexPath) as! SpaceCell
            cell.update(with: item)
            cell.selectionStyle = .none
            return cell
        case .topBooksTitle(item: let item):
            let cell = tableView.dequeueReusableCell(withIdentifier: "labelButtonCell", for: indexPath) as! LabelButtonCell
            cell.update(modelView: item.modelView, modelButton: item.modelButton)
            return cell
        case .sortingButtons(item: let item):
            let cell = tableView.dequeueReusableCell(withIdentifier: "buttonStackCell", for: indexPath) as! ButtonStackTableViewCell
            cell.update(modelButton1: item.modelButton1, modelButton2: item.modelButton2, modelButton3: item.modelButton2)
            return cell
        case .topBooks(let books):
                    let cell = tableView.dequeueReusableCell(withIdentifier: "BooksCollectionViewCell", for: indexPath) as! BooksCollectionViewCell
                    cell.configure(with: [books])
                    return cell
        case .recentTitle(item: let item):
            let cell = tableView.dequeueReusableCell(withIdentifier: "labelButtonCell", for: indexPath) as! LabelButtonCell
            cell.update(modelView: item.modelView, modelButton: item.modelButton)
            return cell
        case .recentBooks(let books):
            let cell = tableView.dequeueReusableCell(withIdentifier: "BooksCollectionViewCell", for: indexPath) as! BooksCollectionViewCell
            cell.configure(with: [books])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch items[indexPath.row] {
        case .topBooks:
            return 270 // Высота BooksCollectionViewCell
        case .recentBooks:
            return 270
        default:
            return UITableView.automaticDimension
        }
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
//        cell.update(with: )
        return cell
    }
}

 

extension MainViewController {
    struct ViewModel {
        
        struct BookItem {
            let imageURL: URL?
            let category: String?
            let title: String?
            let author: String?
        }
        
        enum Item {
            case wishTitle(modelView: UILabel.Model, modelButton: DefaultButton.Model)
            case topBooksTitle(modelView: UILabel.Model, modelButton: DefaultButton.Model)
            case sortingButtons(modelButton1: DefaultButton.Model, modelButton2: DefaultButton.Model, modelButton3: DefaultButton.Model)
            case topBooks(item: MainBookView.Model)
            case recentTitle(modelView: UILabel.Model, modelButton: DefaultButton.Model)
            case recentBooks(item: MainBookView.Model)
            case space(item: SpaceView.Model)
        }
        
        let topBooks: BookItem
        let recentBooks: BookItem
    }
}
