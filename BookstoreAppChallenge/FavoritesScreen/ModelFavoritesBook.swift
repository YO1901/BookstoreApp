//
//  ModelFavoritesBook.swift
//  BookstoreAppChallenge
//
//  Created by Мой Macbook on 09.12.2023.
//

import UIKit

struct FavoritesBook {
    var genre: String?
    var bookTitle: String?
    var author: String?
    var bookImage: URL?
    var removeClosure: () -> Void
}
