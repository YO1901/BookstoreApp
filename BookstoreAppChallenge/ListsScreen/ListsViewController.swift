//
//  ListsViewController.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 14.12.2023.
//

import UIKit

final class ListsViewController: ViewController, ListsViewInput {
    
    typealias ListCell = TableCell<ListButton>
    
    var presenter: ListsViewOutput!
    
    private var items = [ViewModel.Item]()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(ListCell.self, forCellReuseIdentifier: "listCell")
        tv.register(SpaceCell.self, forCellReuseIdentifier: "spaceCell")
        tv.backgroundColor = .clear
        tv.rowHeight = UITableView.automaticDimension
        tv.delegate = self
        tv.dataSource = self
        tv.showsVerticalScrollIndicator = false
        tv.separatorStyle = .none
        tv.delaysContentTouches = false
        return tv
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.update(model: .init(text: "No lists yet"))
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Lists"
        configure()
        configureRightBarButton()
        
        presenter.activate()
    }
    
    func update(with model: ViewModel) {
        items = model.items
        tableView.reloadData()
        tableView.isHidden = items.isEmpty
        emptyLabel.isHidden = !items.isEmpty
    }
    
    func openNewListDialog() {
        let alert = UIAlertController(title: "New List", message: "Enter list name", preferredStyle: .alert)
        alert.addTextField { _ in }
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: .default,
                handler: {
                    [weak presenter, weak alert] _ in
                    
                    presenter?.didEnterNewList(alert?.textFields?.first?.text)
                }
            )
        )
        alert.addAction(.init(title: "Cancel", style: .cancel))
        present(alert, animated: true, completion: nil)
    }
    
    func deleteItem(at: Int) {
        items.remove(at: at)
        tableView.deleteRows(at: [IndexPath(row: at, section: 0)], with: .automatic)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.presenter.activate()
        }
    }
    
    private func configure() {
        view.backgroundColor = Colors.Background.lvl1
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        tableView.contentInset = .init(top: 16, left: 0, bottom: 0, right: 0)
        
        view.addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func configureRightBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: Images.plus,
            style: .plain,
            target: self,
            action: #selector(didTapPlusButton)
        )
    }
    
    @objc
    private func didTapPlusButton() {
        presenter.didTapPlusButton()
    }
}

extension ListsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        switch item {
        case let .list(title: title, didTap: didTap):
            let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! ListCell
            cell.update(
                with: .init(
                    title: title,
                    image: Images.arrowRight,
                    didTapClosure: didTap
                ),
                height: 56
            )
            cell.selectionStyle = .none
            return cell
        case let .space(height: height):
            let cell = tableView.dequeueReusableCell(withIdentifier: "spaceCell", for: indexPath) as! SpaceCell
            cell.update(with: .init(height: height))
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        switch item {
        case let .list(title: title, didTap: _):
            if editingStyle == .delete {
                presenter.deleteList(title, indexPath.row)
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch items[indexPath.row] {
        case .list:
            return true
        default:
            return false
        }
    }
}

extension ListsViewController {
    struct ViewModel {
        enum Item {
            case list(title: String, didTap: () -> Void)
            case space(height: CGFloat)
        }
        
        let items: [Item]
    }
}
