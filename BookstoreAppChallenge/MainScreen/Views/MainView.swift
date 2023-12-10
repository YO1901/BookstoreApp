//
//  MainView.swift
//  BookstoreAppChallenge
//
//  Created by Nikita Shirobokov on 09.12.23.
//

import UIKit

final class MainView: UIView {
    
    private let bookImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let happySearchContainer: UIStackView = {
        let container = UIStackView()
        container.axis = .horizontal
        return container
    }()
    
    private let topBooksAndSeeMoreContainer: UIStackView = {
        let container = UIStackView()
        container.axis = .horizontal
        return container
    }()
    
    private let sortingButtonsContainer: UIStackView = {
        let container = UIStackView()
        container.axis = .horizontal
        container.distribution = .equalSpacing
        return container
    }()
    
    private let recentBooksAndSeeMoreContainer: UIStackView = {
        let container = UIStackView()
        container.axis = .horizontal
        return container
    }()
    
    private let happyTitle = UILabel()
    private let topBooksTitle = UILabel()
    private let recentTitle = UILabel()
    private let seeMoreButton = DefaultButton()
    private let sortingButton = DefaultButton()
    private let searchButton = DefaultButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        [happySearchContainer,
         topBooksAndSeeMoreContainer,
         sortingButtonsContainer,
         recentBooksAndSeeMoreContainer].forEach {addSubview($0)}
        
        [happyTitle, searchButton].forEach {
            happySearchContainer.addArrangedSubview($0)
        }
        [topBooksTitle, seeMoreButton].forEach {
            topBooksAndSeeMoreContainer.addArrangedSubview($0)
        }
        
    }
    
}

extension MainView: Configurable {
    
    struct Model {
        let imageURL: URL?
        let category: NSAttributedString?
        let title: NSAttributedString?
        let author: NSAttributedString?
        let readClosure: () -> Void
    }
    
    enum Item {
        case title(item: UILabel.Model)
        case header(item: BookHeaderView.Model)
        case description(item: UILabel.Model)
        case space(item: SpaceView.Model)
    }
    
    func update(model: Model) {
        <#code#>
    }
}
