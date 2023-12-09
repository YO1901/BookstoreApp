//
//  FavoritesViewController.swift
//  BookstoreAppChallenge
//
//  Created by Nikita Shirobokov on 06.12.23.
//

import UIKit
import SnapKit

final class FavoritesViewController: UIViewController {

    var model = FavoritesBook.makeModel()
    
    //MARK: - Properties
    
    private let favoritesTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(FavoritesTableViewCell.self, forCellReuseIdentifier: FavoritesTableViewCell.identifier)
        return table
    }()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(favoritesTableView)
        setupLayout()
        setupTableView()
    }
    
    //MARK: - Functions
    
    private func setupTableView() {
        favoritesTableView.delegate = self
        favoritesTableView.dataSource = self
        favoritesTableView.rowHeight = 140
        favoritesTableView.sectionFooterHeight = 0
        favoritesTableView.backgroundColor = .white
        favoritesTableView.separatorStyle = .none
    }
    
    private func setupLayout() {
        favoritesTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoritesTableViewCell.identifier, for: indexPath) as? FavoritesTableViewCell else { return UITableViewCell()
        }
        let item = model[indexPath.row]
        cell.update(model: .init(genre: item.genre, bookTitle: item.bookTitle, author: item.author, bookImage: URL(string: "https://covers.openlibrary.org/b/id/921610-M.jpg")))
        cell.selectionStyle = .none
        return cell
    }
}

