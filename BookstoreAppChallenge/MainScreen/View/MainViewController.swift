//
//  MainViewController.swift
//  BookstoreAppChallenge
//
//  Created by Yerlan Omarov on 04.12.2023.
//

import UIKit
import SnapKit

private enum Titles {
    static let happyTitle = "Happy Reading!"
    static let topBooksTitle = "Top Books"
    static let recentTitle = "Recent Books"
    static let seeMoreBtn = "see more"
    static let thisWeekBtn = "This Week"
    static let thisMonthBtn = "This Month"
    static let thisYearBtn = "This Year"
    static let week = "week"
    static let month = "month"
    static let year = "year"
    static let fatalError = "Could not dequeue BookCollectionViewCell"
    static let spaceCell = "spaceCell"
    static let labelButtonCell = "labelButtonCell"
    static let buttonStackCell = "buttonStackCell"
    static let booksCollectionViewCell = "BooksCollectionViewCell"
    static let noCategory = "No Category"
    static let bookCell = "bookCell"
}

final class MainViewController: ViewController {
    
    typealias BookCell = CollectionCell<MainBookView>
    typealias LabelButtonCell = LabelButtonTableViewCell<UILabel, DefaultButton>
    typealias ButtonStackCell = ButtonStackTableViewCell<DefaultButton, DefaultButton, DefaultButton>
    
    var presenter: MainViewPresenterProtocol!
    
    private var items = [ViewModel.Item]()
    private var books = [DocEntity]()
    private var recent = [DocEntity]()
    private var viewModel: ViewModel?
    
    private lazy var searchBar = {
        let search = SearchView()
        search.searchAction = { [weak self] query in
            self?.presenter.searchBooks(query: query)
        }
        return search
    }()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(LabelButtonCell.self, forCellReuseIdentifier: "labelButtonCell")
        tv.register(SpaceCell.self, forCellReuseIdentifier: "spaceCell")
        tv.register(ButtonStackCell.self, forCellReuseIdentifier: "buttonStackCell")
        tv.register(BooksCollectionViewCell.self, forCellReuseIdentifier: "BooksCollectionViewCell")
        tv.backgroundColor = .clear
        tv.rowHeight = UITableView.automaticDimension
        tv.delegate = self
        tv.dataSource = self
        tv.showsVerticalScrollIndicator = false
        tv.allowsSelection = false
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
        layout()
        presenter.activate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func layout() {
        view.backgroundColor = Colors.Background.lvl1
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom)
        }
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
    }
    
    @objc func didTapButton(timePeriod: String) {
        
        switch timePeriod {
        case Titles.thisWeekBtn:
            presenter.switchToTimePeriod(.week)
        case Titles.thisMonthBtn:
            presenter.switchToTimePeriod(.month)
        case Titles.thisYearBtn:
            presenter.switchToTimePeriod(.year)
        case Titles.seeMoreBtn:
            presenter.didTapSeeMoreButton()
        default:
            break
        }
    }
    
    private func makeColonText(text: String?) -> NSAttributedString? {
        guard let text = text else {
            return nil
        }
        return NSAttributedString(string: text, attributes: [.foregroundColor: Colors.whitePrimary])
    }
    
}

extension MainViewController: MainViewProtocol {
    
    func update(with viewModel: ViewModel, forTimePeriod: BooksListRequest.Timeframe) {
        self.viewModel = viewModel
        items.removeAll()
        
        items.append(.space(item: .init(height: 15)))
        
        items.append(.topBooksTitle(
            modelView: .init(
                text: Titles.topBooksTitle,
                textFont: .systemFont(ofSize: 20)),
            modelButton: .init(
                title: Titles.seeMoreBtn,
                font: .systemFont(ofSize: 16),
                type: .onlyText,
                tapAction: { [weak self] in self?.didTapButton(
                    timePeriod: Titles.seeMoreBtn) })))
        
        items.append(.sortingButtons(
            modelButton1: .init(
                title: Titles.thisWeekBtn,
                font: .systemFont(ofSize: 16), type: .sorting,
                tapAction: { [weak self] in self?.didTapButton(
                    timePeriod: Titles.thisWeekBtn) }),
            modelButton2: .init(
                title: Titles.thisMonthBtn,
                font: .systemFont(ofSize: 16), type: .sorting,
                tapAction: { [weak self] in self?.didTapButton(
                    timePeriod: Titles.thisMonthBtn) }),
            modelButton3: .init(
                title: Titles.thisYearBtn,
                font: .systemFont(ofSize: 16),
                type: .sorting, tapAction: { [weak self] in self?.didTapButton(
                    timePeriod: Titles.thisYearBtn) })))
        
        items.append(.topBooks)
        
        items.append(.recentTitle(
            modelView: .init(
                text: Titles.recentTitle,
                textFont: .systemFont(ofSize: 20)),
            modelButton: .init(
                title: Titles.seeMoreBtn,
                font: .systemFont(ofSize: 16), type: .onlyText,
                tapAction: { [weak self] in self?.didTapButton(
                    timePeriod: Titles.seeMoreBtn) })))
        
        items.append(.recentBooks)
        
        // Обновление данных книг
        self.books = viewModel.books
        
        // Перезагрузка tableView, чтобы отобразить новые данные
        tableView.reloadData()
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        
        switch item {
        case .space(item: let item):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: Titles.spaceCell,
                for: indexPath) as! SpaceCell
            cell.update(with: item)
            return cell
            
        case .topBooksTitle(item: let item):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: Titles.labelButtonCell,
                for: indexPath) as! LabelButtonCell
            cell.update(
                modelView: item.modelView,
                modelButton: item.modelButton)
            return cell
            
        case .sortingButtons(item: let item):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: Titles.buttonStackCell,
                for: indexPath) as! ButtonStackTableViewCell
            cell.update(
                modelButton1: item.modelButton1,
                modelButton2: item.modelButton2,
                modelButton3: item.modelButton3)
            return cell
            
        case .topBooks:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: Titles.booksCollectionViewCell,
                for: indexPath) as! BooksCollectionViewCell
            if let bookModels = viewModel?.topBooks.map({ MainBookView.Model(
                imageURL: $0.imageURL,
                category: NSAttributedString(string: $0.category ?? Titles.noCategory),
                title: NSAttributedString(string: $0.title ?? ""),
                author: NSAttributedString(string: $0.author ?? "")) }) {
                cell.configure(with: bookModels)
            }
            cell.books = self.books
            cell.onBookSelect = { [weak self] selectedBook in
                self?.presenter?.showBookDetail(for: selectedBook)
            }
            return cell
            
        case .recentTitle(item: let item):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: Titles.labelButtonCell,
                for: indexPath) as! LabelButtonCell
            cell.update(
                modelView: item.modelView,
                modelButton: item.modelButton)
            return cell
            
        case .recentBooks:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: Titles.booksCollectionViewCell,
                for: indexPath) as! BooksCollectionViewCell
            if let recent = viewModel?.recentBooks {
                let bookModels = recent.map({ MainBookView.Model(
                    imageURL: $0.coverURL(),
                    category: NSAttributedString(string: $0.subject?.first ?? ""),
                    title: NSAttributedString(string: $0.title ),
                    author: NSAttributedString(string: $0.authorName?.first ?? "")) })
                cell.configure(with: bookModels)
                cell.books = recent
                cell.onBookSelect = {
                    [weak self] selectedBook in
                    self?.presenter?.showBookDetail(for: selectedBook)
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch items[indexPath.row] {
        case .topBooks:
            return 270
        case .recentBooks:
            return 270
        default:
            return UITableView.automaticDimension
        }
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Titles.bookCell, for: indexPath) as? BookCell else {
            fatalError(Titles.fatalError)
        }
        let book = books[indexPath.row]
        let model = MainBookView.Model(imageURL: book.coverURL(), category: NSAttributedString(string: book.subject?.first ?? ""), title: NSAttributedString(string: book.title), author: NSAttributedString(string: book.authorName?.first ?? ""))
        cell.update(with: model)
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
            case topBooksTitle(modelView: UILabel.Model, modelButton: DefaultButton.Model)
            case sortingButtons(modelButton1: DefaultButton.Model, modelButton2: DefaultButton.Model, modelButton3: DefaultButton.Model)
            case topBooks
            case recentTitle(modelView: UILabel.Model, modelButton: DefaultButton.Model)
            case recentBooks
            case space(item: SpaceView.Model)
        }
        
        let topBooks: [BookItem]
        let recentBooks: [DocEntity]
        let books: [DocEntity]
    }
}
