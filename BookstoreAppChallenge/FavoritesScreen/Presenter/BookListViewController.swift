//
//  BookListViewController.swift
//  BookstoreAppChallenge
//
//  Created by Nikita Shirobokov on 06.12.23.
//

import UIKit

final class BookListViewController: ViewController {
    
    var presenter: BookListPresenter!
    
    //MARK: - Properties
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(BookListTableViewCell.self, forCellReuseIdentifier: BookListTableViewCell.identifier)
        return table
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.update(model: .init(text: "No books yet"))
        return label
    }()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = presenter.title
        
        view.backgroundColor = Colors.Background.lvl1
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
        setupLayout()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.activate()
    }
    
    //MARK: - Functions
    
    func updateUI() {
        tableView.reloadData()
        tableView.isHidden = presenter.items.isEmpty
        emptyLabel.isHidden = !presenter.items.isEmpty
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 140
        tableView.sectionFooterHeight = 0
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
    }
    
    private func setupLayout() {
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
        
        emptyLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension BookListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookListTableViewCell.identifier, for: indexPath) as? BookListTableViewCell else {
            return UITableViewCell()
        }
        let item = presenter.items[indexPath.row]
        cell.update(
            model: .init(
                genre: item.genre,
                bookTitle: item.bookTitle,
                author: item.author,
                bookImage: item.bookImage,
                deleteAction: item.removeClosure
            )
        )
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelect(indexPath.row)
    }
}

extension BookListViewController {
    struct Book {
        var genre: String?
        var bookTitle: String?
        var author: String?
        var bookImage: URL?
        var removeClosure: (() -> Void)?
    }
}
