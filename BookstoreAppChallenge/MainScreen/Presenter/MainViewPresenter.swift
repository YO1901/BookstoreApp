//
//  MainViewPresenter.swift
//  BookstoreAppChallenge
//
//  Created by Nikita Shirobokov on 09.12.23.
//

import UIKit
import NetworkService

// Input protocol
protocol MainViewProtocol: AnyObject {
    func update(with model: MainViewController.ViewModel)
}

// Output protocol
protocol MainViewPresenterProtocol: AnyObject {
    func activate()
}

private enum Titles {
    static let happyTtile = "Happy Reading!"
    static let topBooksTitle = "Top Books"
    static let recentTitle = "Recent Books"
}

final class MainViewPresenter {
    
    var router: MainViewRouter?
    weak var view: MainViewProtocol?
    
    private let doc: DocEntity
    private let networkManager = NetworkManager()
    
    init(_ doc: DocEntity) {
        self.doc = doc
    }
}

extension MainViewPresenter: MainViewPresenterProtocol {
    
    typealias ViewModel = MainViewController.ViewModel
    
    func activate() {
                view?.update(
                    with: .init(
                        books: [Book(
                            title: "First",
                            author: "Second",
                            coverImage: .logo,
                            category: "Cool")],
                        button: .init(title: "This Week", font: .systemFont(ofSize: 14), type: .stroke, tapAction: {
                            print("Sorting Tapped")
                        }))
                )
        }
    }

