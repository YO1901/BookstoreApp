//
//  MainViewProtocols.swift
//  BookstoreAppChallenge
//
//  Created by Nikita Shirobokov on 13.12.23.
//

// Input protocol
protocol MainViewProtocol: AnyObject {
    func update(with viewModel: MainViewController.ViewModel)
    func startLoader()
    func stopLoader()
}

// Output protocol
protocol MainViewPresenterProtocol: AnyObject {
    func fetchBooksList(for timePeriod: BooksListRequest.Timeframe, completion: @escaping ([MainViewController.ViewModel.BookItem], [DocsEntity]) -> Void)
    func fetchBooksList(for timePeriod: BooksListRequest.Timeframe)
    func activate()
        func switchToTimePeriod(_ timePeriod: BooksListRequest.Timeframe)
}
