//
//  MainViewProtocols.swift
//  BookstoreAppChallenge
//
//  Created by Nikita Shirobokov on 13.12.23.
//

// Input protocol
protocol MainViewProtocol: AnyObject {
    func update(with viewModel: MainViewController.ViewModel, 
                forTimePeriod: BooksListRequest.Timeframe)
    func showLoading()
    func hideLoading()
}

// Output protocol
protocol MainViewPresenterProtocol: AnyObject {
    func didTapSeeMoreButton()
    func searchBooks(query: String)
    var router: MainViewRouter? { get set }
    func activate()
    func switchToTimePeriod(_ timePeriod: BooksListRequest.Timeframe)
    func showBookDetail(for book: DocEntity)
}

