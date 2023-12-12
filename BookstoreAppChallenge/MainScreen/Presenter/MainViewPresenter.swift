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
        view?.update(with: .init(imageURL: doc.coverURL(), author: doc.authorName?.first, title: doc.title, category: doc.subject?.first))
        }
    }

