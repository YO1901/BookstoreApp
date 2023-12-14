//
//  FavoritesPresenter.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 12.12.2023.
//

import UIKit

final class FavoritesPresenter {
    
    var router: FavoritesRouter?
    weak var view: FavoritesViewController?
    
    var items = [FavoritesBook]()
    var title = "Likes"
    
    private var books = [OpenBook]()
    private var listTitle = ""
    
    init(_ listTitle: String? = nil) {
        if let listTitle {
            self.listTitle = listTitle
            self.title = listTitle
        } else {
            self.listTitle = "Likes"
        }
    }
    
    func activate() {
        loadBooks()
        view?.updateUI()
    }
    
    private func loadBooks() {
        guard let books = CoreDataService.shared.getLists()
            .first(where: { $0.title == self.listTitle })?
            .book?.array as? [OpenBook] else {
            return
        }
        self.books = books
        items = books.map {
            let openBook = $0
            return FavoritesBook(
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
    }
}
