import UIKit
import NetworkService

final class MainViewPresenter: MainViewPresenterProtocol {

    var router: MainViewRouter?
    weak var view: MainViewProtocol?
    
    private let networkManager = NetworkManager()
    
    // Данные для каждого временного периода
    private var weekData: ([MainViewController.ViewModel.BookItem], [DocEntity]) = ([], [])
    private var monthData: ([MainViewController.ViewModel.BookItem], [DocEntity]) = ([], [])
    private var yearData: ([MainViewController.ViewModel.BookItem], [DocEntity]) = ([], [])

    // Запуск первоначальной загрузки данных
    func activate() {
        view?.showLoading()

        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        fetchBooksList(for: .week) { [weak self] (items, Doc) in
            self?.weekData = (items, Doc)
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        fetchBooksList(for: .month) { [weak self] (items, Doc) in
            self?.monthData = (items, Doc)
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        fetchBooksList(for: .year) { [weak self] (items, Doc) in
            self?.yearData = (items, Doc)
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) {
            self.view?.hideLoading()
            self.updateView(with: self.weekData.0 , DocEntities: self.weekData.1 )
        }
    }


    // Обработка переключения между временными периодами
    func switchToTimePeriod(_ timePeriod: BooksListRequest.Timeframe) {
        switch timePeriod {
        case .week:
            updateView(with: weekData.0, DocEntities: weekData.1)
        case .month:
            updateView(with: monthData.0, DocEntities: monthData.1)
        case .year:
            updateView(with: yearData.0, DocEntities: yearData.1)
        }
    }
    
    func fetchBooksList(for timePeriod: BooksListRequest.Timeframe) {
           fetchBooksList(for: timePeriod) { [weak self] bookItems, DocEntities in
               self?.updateView(with: bookItems, DocEntities: DocEntities)
           }
       }
    
    func fetchBooksList(for timePeriod: BooksListRequest.Timeframe, completion: @escaping ([MainViewController.ViewModel.BookItem], [DocEntity]) -> Void) {
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

    private func updateView(with bookItems: [MainViewController.ViewModel.BookItem], DocEntities: [DocEntity]) {
        let viewModel = MainViewController.ViewModel(
            topBooks: bookItems,
            recentBooks: bookItems,
            books: DocEntities
        )
        self.view?.update(with: viewModel)
    }
}
