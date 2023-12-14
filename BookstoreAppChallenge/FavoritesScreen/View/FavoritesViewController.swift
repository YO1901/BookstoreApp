//
//  FavoritesViewController.swift
//  BookstoreAppChallenge
//
//  Created by Nikita Shirobokov on 06.12.23.
//

import UIKit
import SnapKit

final class FavoritesViewController: ViewController {
    
    var presenter: FavoritesPresenter!
    
    //MARK: - Properties
    
    private let favoritesTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(FavoritesTableViewCell.self, forCellReuseIdentifier: FavoritesTableViewCell.identifier)
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
        view.addSubview(favoritesTableView)
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
        favoritesTableView.reloadData()
        favoritesTableView.isHidden = presenter.items.isEmpty
        emptyLabel.isHidden = !presenter.items.isEmpty
    }
    
    private func setupTableView() {
        favoritesTableView.delegate = self
        favoritesTableView.dataSource = self
        favoritesTableView.rowHeight = 140
        favoritesTableView.sectionFooterHeight = 0
        favoritesTableView.backgroundColor = .clear
        favoritesTableView.separatorStyle = .none
    }
    
    private func setupLayout() {
        favoritesTableView.snp.makeConstraints { make in
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

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoritesTableViewCell.identifier, for: indexPath) as? FavoritesTableViewCell else { return UITableViewCell()
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

