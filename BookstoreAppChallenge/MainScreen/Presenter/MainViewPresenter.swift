//
//  MainViewPresenter.swift
//  BookstoreAppChallenge
//
//  Created by Nikita Shirobokov on 09.12.23.
//

import UIKit
import NetworkService

final class MainViewPresenter: MainViewPresenterProtocol {

    var router: MainViewRouter?
    weak var view: MainViewProtocol?
    
    private let networkManager = NetworkManager()

    // Возможно, метод activate() больше не нужен, если он не используется
    func activate() {
        // Здесь могла быть ваша логика, если метод все еще нужен
    }

    func fetchBooksList(for timePeriod: BooksListRequest.Timeframe) {
            networkManager.sendRequest(request: BooksListRequest(timeframe: timePeriod)) { [weak self] result in
                switch result {
                case .success(let booksList):
                    let bookItems = booksList.docs.map { doc -> MainViewController.ViewModel.BookItem in
                        return MainViewController.ViewModel.BookItem(
                            imageURL: doc.coverURL(),
                            category: doc.subject?.first,
                            title: doc.title,
                            author: doc.authorName?.first)
                    }
                    // Передаем список книг в ViewModel
                    let viewModel = MainViewController.ViewModel(
                        topBooks: bookItems,
                        recentBooks: bookItems,
                        books: booksList.docs)
                    self?.view?.update(with: viewModel)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }


