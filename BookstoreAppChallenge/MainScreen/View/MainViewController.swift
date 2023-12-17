//
//  MainViewController.swift
//  BookstoreAppChallenge
//
//  Created by Yerlan Omarov on 04.12.2023.
//

import UIKit
import SnapKit

private extension CGFloat {
    static let loaderDimention: CGFloat = 128
}

final class MainViewController: ViewController {
    
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
    private var books = [DocEntity]()
    private var recent = [DocEntity]()
    private var viewModel: ViewModel?
    
    private lazy var button: DefaultButton = {
        let btn = DefaultButton()
        return btn
    }()
    
    private lazy var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.style = .large
        loader.color = .blue
        return loader
    }()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(LabelButtonCell.self, forCellReuseIdentifier: "labelButtonCell")
        tv.register(SpaceCell.self, forCellReuseIdentifier: "spaceCell")
        tv.register(SearchCell.self, forCellReuseIdentifier: "searchCell")
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
        
        view.backgroundColor = Colors.Background.lvl1
        setupLoader()
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
        //        presenter.fetchBooksList(for: .week)
        presenter.activate()
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
    
    @objc func didTapButtonWeek() {
        presenter.switchToTimePeriod(.week)
    }
    
    @objc func didTapButtonMonth() {
        presenter.switchToTimePeriod(.month)
    }
    @objc func didTapButtonYear() {
        presenter.switchToTimePeriod(.year)
    }
    
    @objc func didTapSeeMoreTopBooks() {
        presenter.didTapSeeMoreButton()
    }

    private func setupLoader() {
        view.addSubview(loader)
        loader.snp.makeConstraints { make in
            make.size.equalTo(CGFloat.loaderDimention)
            make.center.equalToSuperview()
        }
    }
    
    private func makeColonText(text: String?) -> NSAttributedString? {
        guard let text = text else {
            return nil
        }
        return NSAttributedString(string: text, attributes: [.foregroundColor: Colors.whitePrimary])
    }
    
    func startLoader() {
        loader.startAnimating()
        loader.isHidden = false
        tableView.isHidden = true
    }
    
    func stopLoader() {
        loader.stopAnimating()
        tableView.isHidden = false
        tableView.reloadData()
    }
    
}

extension MainViewController: MainViewProtocol {
    
    func update(with viewModel: ViewModel, forTimePeriod: BooksListRequest.Timeframe) {
        
        self.viewModel = viewModel
        items.removeAll()
        
//        items.append(.wishTitle(
//            modelView: .init(text: Titles.happyTitle, textFont: .systemFont(ofSize: 16)),
//            modelButton: .init(type: .search, tapAction: didTapButtonWeek)))
        items.append(.search)
        items.append(.space(item: .init(height: 15)))
        items.append(.topBooksTitle(
            modelView: .init(text: Titles.topBooksTitle, textFont: .systemFont(ofSize: 20)),
            modelButton: .init(title: Titles.seeMoreBtn, font: .systemFont(ofSize: 16), type: .onlyText, tapAction: didTapSeeMoreTopBooks)))
        items.append(.sortingButtons(modelButton1: .init(title: Titles.thisWeekBtn, font: .systemFont(ofSize: 16), type: .sorting, tapAction: didTapButtonWeek), modelButton2: .init(title: Titles.thisMonthBtn, font: .systemFont(ofSize: 16), type: .sorting, tapAction: didTapButtonMonth), modelButton3: .init(title: Titles.thisYearBtn, font: .systemFont(ofSize: 16), type: .sorting, tapAction: didTapButtonYear)))
        items.append(.topBooks)
        items.append(.recentTitle(
            modelView: .init(text: Titles.recentTitle, textFont: .systemFont(ofSize: 20)),
            modelButton: .init(title: Titles.seeMoreBtn, font: .systemFont(ofSize: 16), type: .onlyText, tapAction: didTapButtonWeek)))
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
//        case .wishTitle(item: let item):
//            let cell = tableView.dequeueReusableCell(withIdentifier: "labelButtonCell", for: indexPath) as! LabelButtonCell
//            cell.update(modelView: item.modelView, modelButton: item.modelButton)
//            cell.selectionStyle = .none
//            return cell
        case.search:
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchCell
            cell.searchAction = { [weak self] query in
                self?.presenter.searchBooks(query: query)
            }
            return cell
        case .space(item: let item):
            let cell = tableView.dequeueReusableCell(withIdentifier: "spaceCell", for: indexPath) as! SpaceCell
            cell.update(with: item)
            cell.selectionStyle = .none
            return cell
        case .topBooksTitle(item: let item):
            let cell = tableView.dequeueReusableCell(withIdentifier: "labelButtonCell", for: indexPath) as! LabelButtonCell
            cell.update(modelView: item.modelView, modelButton: item.modelButton)
            cell.selectionStyle = .none
            return cell
        case .sortingButtons(item: let item):
            let cell = tableView.dequeueReusableCell(withIdentifier: "buttonStackCell", for: indexPath) as! ButtonStackTableViewCell
            cell.update(modelButton1: item.modelButton1, modelButton2: item.modelButton2, modelButton3: item.modelButton3)
            cell.selectionStyle = .none
            return cell
        case .topBooks:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BooksCollectionViewCell", for: indexPath) as! BooksCollectionViewCell
            if let bookModels = viewModel?.topBooks.map({ MainBookView.Model(imageURL: $0.imageURL, category: NSAttributedString(string: $0.category ?? "No Category"), title: NSAttributedString(string: $0.title ?? ""), author: NSAttributedString(string: $0.author ?? "")) }) {
                cell.configure(with: bookModels)
            }
            cell.books = self.books // Передайте массив книг
            cell.onBookSelect = { [weak self] selectedBook in
                self?.presenter?.showBookDetail(for: selectedBook)
            }
            cell.selectionStyle = .none
            return cell
        case .recentTitle(item: let item):
            let cell = tableView.dequeueReusableCell(withIdentifier: "labelButtonCell", for: indexPath) as! LabelButtonCell
            cell.update(modelView: item.modelView, modelButton: item.modelButton)
            cell.selectionStyle = .none
            return cell
        case .recentBooks:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BooksCollectionViewCell", for: indexPath) as! BooksCollectionViewCell
            let bookModels = books.map { MainBookView.Model(imageURL: $0.coverURL(), category: NSAttributedString(string: $0.subject?.first ?? ""), title: NSAttributedString(string: $0.title), author: NSAttributedString(string: $0.authorName?.first ?? "")) }
            cell.configure(with: bookModels)
            cell.selectionStyle = .none
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
        return books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bookCell", for: indexPath) as? BookCell else {
            fatalError("Could not dequeue BookCollectionViewCell")
        }
        let book = books[indexPath.row]
        let model = MainBookView.Model(imageURL: book.coverURL(), category: NSAttributedString(string: book.subject?.first ?? ""), title: NSAttributedString(string: book.title), author: NSAttributedString(string: book.authorName?.first ?? ""))
        cell.update(with: model)
        return cell
    }
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let searchCell = cell as? SearchCell {
            DispatchQueue.main.async {
                searchCell.searchTextField.becomeFirstResponder()
            }
        }
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
//            case wishTitle(modelView: UILabel.Model, modelButton: DefaultButton.Model)
            case search
            case topBooksTitle(modelView: UILabel.Model, modelButton: DefaultButton.Model)
            case sortingButtons(modelButton1: DefaultButton.Model, modelButton2: DefaultButton.Model, modelButton3: DefaultButton.Model)
            case topBooks
            case recentTitle(modelView: UILabel.Model, modelButton: DefaultButton.Model)
            case recentBooks
            case space(item: SpaceView.Model)
        }
        
        let topBooks: [BookItem]
        let recentBooks: [BookItem]
        let books: [DocEntity]
    }
}


