//
//  MainViewPresenter.swift
//  BookstoreAppChallenge
//
//  Created by Nikita Shirobokov on 09.12.23.
//

import UIKit
import NetworkService

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
        networkManager.sendRequest(request: BookRequest(key: doc.key)) {
            [weak self] result in
            
            guard let self else {
                return
            }
            
            switch result {
            case .success:
                view?.update(
                    with: .init(
                        topBooks: .init(imageURL: doc.coverURL(), category: doc.subject?.first, title: doc.title, author: doc.authorName?.first),
                        recentBooks: .init(imageURL: doc.coverURL(), category: doc.subject?.first, title: doc.title, author: doc.authorName?.first))
                )
            case .failure(let error):
                print(error)
            }
        }
    }
//    func activate() {
//        networkManager.sendRequest(request: SearchBookRequest(query: <#T##String#>, sort: <#T##SearchBookRequest.SortKey?#>), completionHandler: <#T##(Result<Decodable, Error>) -> Void#>)
//    }
}

