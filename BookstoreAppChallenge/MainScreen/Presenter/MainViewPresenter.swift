import UIKit
import NetworkService

final class MainViewPresenter: MainViewPresenterProtocol {

    var router: MainViewRouter?
    weak var view: MainViewProtocol?
    
    private let networkManager = NetworkManager()
    
    // Данные для каждого временного периода
    private var weekData: [MainViewController.ViewModel.BookItem] = []
    private var monthData: [MainViewController.ViewModel.BookItem] = []
    private var yearData: [MainViewController.ViewModel.BookItem] = []

    // Запуск первоначальной загрузки данных
    func activate() {
        fetchBooksList(for: .week) { [weak self] items in
            self?.weekData = items
            self?.updateView(with: items)
        }
        fetchBooksList(for: .month) { [weak self] items in
            self?.monthData = items
        }
        fetchBooksList(for: .year) { [weak self] items in
            self?.yearData = items
        }
    }

    // Обработка переключения между временными периодами
    func switchToTimePeriod(_ timePeriod: BooksListRequest.Timeframe) {
        switch timePeriod {
        case .week:
            updateView(with: weekData)
        case .month:
            updateView(with: monthData)
        case .year:
            updateView(with: yearData)
        }
    }

    func fetchBooksList(for timePeriod: BooksListRequest.Timeframe, completion: @escaping ([MainViewController.ViewModel.BookItem]) -> Void) {
        networkManager.sendRequest(request: BooksListRequest(timeframe: timePeriod)) { [weak self] result in
            switch result {
            case .success(let booksListEntity):
                let group = DispatchGroup()
                var bookItems: [MainViewController.ViewModel.BookItem] = []

                for doc in booksListEntity.works {
                    group.enter()
                    self?.fetchBookDetails(bookKey: doc.key) { category in
                        let bookItem = MainViewController.ViewModel.BookItem(
                            imageURL: doc.coverURL(),
                            category: category,
                            title: doc.title,
                            author: doc.authorName?.first)
                        bookItems.append(bookItem)
                        group.leave()
                    }
                }
                
                group.notify(queue: .main) {
                    completion(bookItems)
                }
            case .failure(let error):
                print(error)
                completion([])
            }
        }
    }

    private func fetchBookDetails(bookKey: String, completion: @escaping (String?) -> Void) {
        networkManager.sendRequest(request: BookDetailRequest(bookKey: bookKey)) { result in
            switch result {
            case .success(let bookDetail):
                let category = bookDetail.subjects?.first
                completion(category)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }

    private func updateView(with bookItems: [MainViewController.ViewModel.BookItem]) {
        let viewModel = MainViewController.ViewModel(
            topBooks: bookItems,
            recentBooks: bookItems,
            books: bookItems.map { DocsEntity(from: $0) }) // Преобразование в DocsEntity, если требуется
        self.view?.update(with: viewModel)
    }
}
