//
//  MainViewController.swift
//  BookstoreAppChallenge
//
//  Created by Yerlan Omarov on 04.12.2023.
//

import UIKit
import SnapKit

final class MainViewController: UIViewController {
    
    typealias TextCell = TableCell<UILabel>
    typealias HeaderCell = TableCell<BookHeaderView>
    
    var presenter: MainViewPresenterProtocol!
    
    private var items = [ViewModel.Item]()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(TextCell.self, forCellReuseIdentifier: "textCell")
        tv.register(HeaderCell.self, forCellReuseIdentifier: "headerCell")
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.activate()
        view.backgroundColor = .white
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
        case .title(item: let item):
            let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as! TextCell
            cell.update(with: item)
            cell.selectionStyle = .none
            return cell
        case .description(item: let item):
            let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as! TextCell
            cell.update(with: item)
            cell.selectionStyle = .none
            return cell
        case .space(item: let item):
            let cell = tableView.dequeueReusableCell(withIdentifier: "spaceCell", for: indexPath) as! SpaceCell
            cell.update(with: item)
            cell.selectionStyle = .none
            return cell
        case .header(item: let item):
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath) as! HeaderCell
            cell.update(with: item)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
}

extension MainViewController {
    struct ViewModel {
        struct Item {
            let book: Book
        }
        
        let books: [Book]
        let button: DefaultButton.Model
    }
}
