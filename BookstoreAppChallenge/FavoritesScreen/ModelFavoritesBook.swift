//
//  ModelFavoritesBook.swift
//  BookstoreAppChallenge
//
//  Created by Мой Macbook on 09.12.2023.
//

import UIKit

struct FavoritesBook {
    var genre: String
    var bookTitle: String
    var author: String
    var bookImage: String
    
    static func makeModel() -> [FavoritesBook] {
        var favoritesBookModel = [FavoritesBook]()
        favoritesBookModel.append(FavoritesBook(genre: "Novel", bookTitle: "Tuesday Mooney Talks to Ghosts", author: "Kate Racculia", bookImage: "book"))
        favoritesBookModel.append(FavoritesBook(genre: "Adult Narrative", bookTitle: "Hello, Dream", author: "Cristina Camerena, Lady Desatia", bookImage: "book1"))
        return favoritesBookModel
    }
}
