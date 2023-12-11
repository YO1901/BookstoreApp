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
    
    func activate() {
        loadBooks()
        view?.updateUI()
    }
    
    private func loadBooks() {
        guard let books = CoreDataService.shared.getFavoritesList().book?.array as? [OpenBook] else {
            return
        }
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
}
