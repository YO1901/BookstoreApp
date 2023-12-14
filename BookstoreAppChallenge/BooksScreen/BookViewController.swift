//
//  BookViewController.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 06.12.2023.
//

import UIKit

final class BookViewController: ViewController, BookInput {
    
    typealias TextCell = TableCell<UILabel>
    typealias HeaderCell = TableCell<BookHeaderView>
    
    var presenter: BookOutput!
    
    private var items = [ViewModel.Item]()
    private var likeBarButtonAction: (() -> Void)?
    
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
        tv.contentInset = .init(top: 16, left: 0, bottom: 0, right: 0)
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        presenter.activate()
    }
    
    func update(with model: ViewModel) {
        
        title = model.category
        
        self.likeBarButtonAction = model.likeBarButtonAction
        if model.likeBarButtonAction != nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: Images.heart.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(didTapLikeBarButton))
        } else {
            navigationItem.rightBarButtonItem = nil
        }
        
        items.removeAll()
        items.append(
            .title(
                item: .init(
                    text: model.title,
                    textFont: .systemFont(ofSize: 24, weight: .semibold),
                    textColor: Colors.blackPrimary
                )
            )
        )
        items.append(.space(item: .init(height: 16)))
        items.append(
            .header(
                item: .init(
                    imageURL: model.header.imageURL,
                    author: makeColonText(left: "Author", right: model.header.author),
                    category: makeColonText(left: "Category", right: model.header.category),
                    rating: makeColonText(left: "Rating", right: model.header.rating),
                    addToListClosure: model.header.addToListClosure,
                    readClosure: model.header.readClosure
                )
            )
        )
        items.append(.space(item: .init(height: 18)))
        items.append(.description(item: .init(text: model.description)))
        items.append(.space(item: .init(height: 20)))
        tableView.reloadData()
    }
    
    private func configure() {
        
        view.backgroundColor = Colors.Background.lvl1
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.bottom.equalToSuperview()
        }
    }
    
    private func makeColonText(left: String, right: String?) -> NSAttributedString? {
        guard let right else {
            return nil
        }
        let result = NSMutableAttributedString()
        let leftPart = NSAttributedString(string: "\(left) : ", attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .regular), .foregroundColor: Colors.blackPrimary])
        let rightPart = NSAttributedString(string: right, attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .semibold), .foregroundColor: Colors.blackPrimary])
        result.append(leftPart)
        result.append(rightPart)
        return result
    }
    
    @objc
    private func didTapLikeBarButton() {
        likeBarButtonAction?()
    }
}

extension BookViewController: UITableViewDelegate, UITableViewDataSource {
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

extension BookViewController {
    struct ViewModel {
        
        struct HeaderItem {
            let imageURL: URL?
            let author: String?
            let category: String?
            let rating: String?
            let addToListClosure: (() -> Void)
            let readClosure: (() -> Void)
        }
        
        enum Item {
            case title(item: UILabel.Model)
            case header(item: BookHeaderView.Model)
            case description(item: UILabel.Model)
            case space(item: SpaceView.Model)
        }
        
        let title: String
        let category: String?
        let header: HeaderItem
        let description: String
        let likeBarButtonAction: (() -> Void)?
    }
}
