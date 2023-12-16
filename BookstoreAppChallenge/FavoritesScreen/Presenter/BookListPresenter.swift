//
//  BookListPresenter.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 12.12.2023.
//

import UIKit

final class BookListPresenter {
    
    typealias Book = BookListViewController.Book
    
    var router: BookListRouter?
    weak var view: BookListViewController?
    
    var items = [Book]()
    var title = "Likes"
    
    private var books = [OpenBook]()
    private var docs = [DocEntity]()
    private var listTitle = ""
    private let flow: BookListRouter.Flow
    
    init(_ flow: BookListRouter.Flow) {
        self.flow = flow
        
        switch flow {
        case .likes:
            self.listTitle = "Likes"
            self.title = "Likes"
        case let .list(title: title):
            self.listTitle = title
            self.title = title
        case let .seeMore(title: title, books: docs):
            self.title = title
            self.docs = docs
            self.items = docs.map {
                .init(
                    genre: $0.subject?.first,
                    bookTitle: $0.title,
                    author: $0.authorName?.first,
                    bookImage: $0.coverURL()
                )
            }
        }
    }
    
    func activate() {
        switch flow {
        case .likes, .list:
            loadBooks()
        case .seeMore:
            view?.updateUI()
        }
    }
    
    private func showBooks() {
        
    }
    
    private func loadBooks() {
        guard let books = CoreDataService.shared.getLists()
            .first(where: { $0.title == self.listTitle })?
            .book?.array as? [OpenBook] else {
            return
        }
        self.books = books
        items = books.sorted(by: { $0.addedDate < $1.addedDate }).map {
            let openBook = $0
            return Book(
                genre: $0.subject,
                bookTitle: $0.title,
                author: $0.author,
                bookImage: URL(string: $0.imageURL ?? ""),
                removeClosure: {
                    [weak self] in
                    
                    CoreDataService.shared.managedContext.delete(openBook)
                    CoreDataService.shared.saveContext()
                    self?.loadBooks()
                    self?.view?.updateUI()
                }
            )
        }
    }
    
    func didSelect(_ index: Int) {
        switch flow {
        case .likes, .list:
            let book = books[index]
            router?.openBookScreen(
                doc: .init(
                    key: book.key,
                    title: book.title ?? "",
                    authorName: [book.author ?? ""],
                    subject: [book.subject ?? ""],
                    firstPublishYear: nil,
                    coverI: book.coverI != 0 ? Int(book.coverI) : nil,
                    ratingsAverage: book.rating != 0 ? book.rating : nil
                )
            )
        case .seeMore:
            let doc = docs[index]
            router?.openBookScreen(
                doc: doc
            )
        }
    }
}
