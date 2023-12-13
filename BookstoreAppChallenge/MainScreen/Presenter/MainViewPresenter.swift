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
    
//    private let doc: DocEntity
//    private let networkManager = NetworkManager()
    
//    init(_ doc: DocEntity) {
//        self.doc = doc
//    }
}

extension MainViewPresenter: MainViewPresenterProtocol {
    
    typealias ViewModel = MainViewController.ViewModel
    
    func activate() {
//        view?.update(with: .init(imageURL: doc.coverURL(), author: doc.authorName?.first, title: doc.title, category: doc.subject?.first))
        view?.update()
        }
    }

