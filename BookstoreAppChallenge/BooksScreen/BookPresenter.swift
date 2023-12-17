//
//  BookPresenter.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 06.12.2023.
//

import Foundation
import UIKit
import NetworkService
import CoreData

final class BookPresenter: BookOutput {
    
    var router: BookRouter?
    weak var view: BookInput?
    
    private let doc: DocEntity
    private let networkManager = NetworkManager()
    
    init(_ doc: DocEntity) {
        self.doc = doc
    }
    
    func activate() {
        view?.showLoading()
        networkManager.sendRequest(request: BookRequest(key: doc.key)) {
            [weak self] result in
            
            guard let self else {
                return
            }
            
            switch result {
            case .success(let book):
                
                let rating: String? = {
                    guard let ratings = self.doc.ratingsAverage else {
                        return nil
                    }
                    return "\(Double(Int(ratings * 100)) / 100) / 5"
                }()
                
                view?.hideLoading()
                view?.update(
                    with: .init(
                        title: doc.title,
                        category: doc.subject?.first,
                        header: .init(
                            imageURL: doc.coverURL(),
                            author: doc.authorName?.first,
                            category: doc.subject?.first,
                            rating: rating,
                            addToListClosure: {
                                [weak self] in
                                
                                guard let self else { return }
                                router?.openListsScreen(selectListClosure: {
                                    [weak self] title in
                                    
                                    self?.addToList(title)
                                    self?.router?.dissmissPresented()
                                })
                            },
                            readClosure: {
                                [weak self] in
                                
                                guard let self else { return }
                                guard let url = doc.readURL else {
                                    return
                                }
                                UIApplication.shared.open(url)
                            }
                        ),
                        description: book.description ?? "",
                        likeBarButtonAction: {
                            [weak self] in
                            
                            self?.addToLikes()
                        }
                    )
                )
                addToRecent()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func saveBook(list: OpenBookList) {
        let book = OpenBook(context: CoreDataService.shared.managedContext)
        book.setValue(doc.authorName?.first, forKey: #keyPath(OpenBook.author))
        book.setValue(doc.title, forKey: #keyPath(OpenBook.title))
        book.setValue(doc.subject?.first, forKey: #keyPath(OpenBook.subject))
        book.setValue(doc.coverURL()?.absoluteString, forKey: #keyPath(OpenBook.imageURL))
        book.setValue(doc.cover ?? 0, forKey: #keyPath(OpenBook.coverI))
        book.setValue(doc.key, forKey: #keyPath(OpenBook.key))
        book.setValue(list, forKey: #keyPath(OpenBook.bookList))
        book.setValue(doc.ratingsAverage ?? 0, forKey: #keyPath(OpenBook.rating))
        book.setValue(Date(), forKey: #keyPath(OpenBook.addedDate))
        
        CoreDataService.shared.saveContext()
    }
    
    private func addToLikes() {
        let list = CoreDataService.shared.getLikesList()
        let books = list.book?.compactMap { $0 as? OpenBook }
        guard books?.contains(where: { $0.key == doc.key }) == false else {
            return
        }
        
        saveBook(list: list)
    }
    
    private func addToRecent() {
        let list = CoreDataService.shared.getRecentList()
        let books = list.book?.compactMap { $0 as? OpenBook }
        if let savedBook = books?.first(where: { $0.key == doc.key }) {
            CoreDataService.shared.managedContext.delete(savedBook)
        }
        
        saveBook(list: list)
        CoreDataService.shared.recentObservers.forEach{ $0() }
    }
    
    private func addToList(_ title: String) {
        guard let list = CoreDataService.shared.getLists().first(where: { $0.title == title }) else {
            return
        }
        let books = list.book?.compactMap { $0 as? OpenBook }
        guard books?.contains(where: { $0.key == doc.key }) == false else {
            return
        }
        
        saveBook(list: list)
    }
}
