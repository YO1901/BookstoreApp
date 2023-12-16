//
//  MainViewProtocols.swift
//  BookstoreAppChallenge
//
//  Created by Nikita Shirobokov on 13.12.23.
//

// Input protocol
protocol MainViewProtocol: AnyObject {
    func update(with viewModel: MainViewController.ViewModel)
    func showLoading()
    func hideLoading()
}

// Output protocol
protocol MainViewPresenterProtocol: AnyObject {
    func fetchBooksList(for timePeriod: BooksListRequest.Timeframe, completion: @escaping ([MainViewController.ViewModel.BookItem], [DocEntity]) -> Void)
    func fetchBooksList(for timePeriod: BooksListRequest.Timeframe)
    func activate()
        func switchToTimePeriod(_ timePeriod: BooksListRequest.Timeframe)
}
