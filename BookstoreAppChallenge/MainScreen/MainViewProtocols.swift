//
//  MainViewProtocols.swift
//  BookstoreAppChallenge
//
//  Created by Nikita Shirobokov on 13.12.23.
//

// Input protocol
protocol MainViewProtocol: AnyObject {
    func update(with viewModel: MainViewController.ViewModel, 
                forTimePeriod: BooksListRequest.Timeframe,
                updateRecentBooks: Bool)
    func showLoading()
    func hideLoading()
}

extension MainViewProtocol {
    func update(with viewModel: MainViewController.ViewModel, forTimePeriod: BooksListRequest.Timeframe) {
        update(with: viewModel, forTimePeriod: forTimePeriod, updateRecentBooks: true)
    }
}

// Output protocol
protocol MainViewPresenterProtocol: AnyObject {
    func didTapSeeMoreButton()
    func searchBooks(query: String)
    var router: MainViewRouter? { get set }
    func activate()
    func switchToTimePeriod(_ timePeriod: BooksListRequest.Timeframe, updateRecent: Bool)
    func showBookDetail(for book: DocEntity)
}

