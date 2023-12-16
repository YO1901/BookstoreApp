import UIKit
import NetworkService

final class MainViewPresenter: MainViewPresenterProtocol {

    var router: MainViewRouter?
    weak var view: MainViewProtocol?
    
    private let networkManager = NetworkManager()
    
    // Данные для каждого временного периода
    private var weekData: ([MainViewController.ViewModel.BookItem], [DocsEntity]) = ([], [])
    private var monthData: ([MainViewController.ViewModel.BookItem], [DocsEntity]) = ([], [])
    private var yearData: ([MainViewController.ViewModel.BookItem], [DocsEntity]) = ([], [])

    // Запуск первоначальной загрузки данных
    func activate() {
        view?.startLoader()

        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        fetchBooksList(for: .week) { [weak self] (items, docs) in
            self?.weekData = (items, docs)
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        fetchBooksList(for: .month) { [weak self] (items, docs) in
            self?.monthData = (items, docs)
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        fetchBooksList(for: .year) { [weak self] (items, docs) in
            self?.yearData = (items, docs)
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) {
            self.view?.stopLoader()
            self.updateView(with: self.weekData.0 , docsEntities: self.weekData.1 )
        }
    }


    // Обработка переключения между временными периодами
    func switchToTimePeriod(_ timePeriod: BooksListRequest.Timeframe) {
        switch timePeriod {
        case .week:
            updateView(with: weekData.0, docsEntities: weekData.1)
        case .month:
            updateView(with: monthData.0, docsEntities: monthData.1)
        case .year:
            updateView(with: yearData.0, docsEntities: yearData.1)
        }
    }
    
    func fetchBooksList(for timePeriod: BooksListRequest.Timeframe) {
           fetchBooksList(for: timePeriod) { [weak self] bookItems, docsEntities in
               self?.updateView(with: bookItems, docsEntities: docsEntities)
           }
       }
    
    func fetchBooksList(for timePeriod: BooksListRequest.Timeframe, completion: @escaping ([MainViewController.ViewModel.BookItem], [DocsEntity]) -> Void) {
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
                    completion(bookItems, booksListEntity.works)
                }
            case .failure(let error):
                print(error)
                completion([], [])
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

    private func updateView(with bookItems: [MainViewController.ViewModel.BookItem], docsEntities: [DocsEntity]) {
        let viewModel = MainViewController.ViewModel(
            topBooks: bookItems,
            recentBooks: bookItems,
            books: docsEntities
        )
        self.view?.update(with: viewModel)
    }
}
