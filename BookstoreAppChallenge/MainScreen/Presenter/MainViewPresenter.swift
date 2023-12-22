import UIKit
import NetworkService

final class MainViewPresenter: MainViewPresenterProtocol {
    
    var router: MainViewRouter?
    weak var view: MainViewProtocol?
    private let networkManager = NetworkManager()
    private var bookData: [BooksListRequest.Timeframe: ([MainViewController.ViewModel.BookItem], [DocEntity])] = [:]
    private var timePeriod: BooksListRequest.Timeframe = .week
    private var recentBooks: [DocEntity] {
        guard let recent = CoreDataService.shared.getRecentList().book?.array.compactMap({ $0 as? OpenBook }).sorted(by: { $0.addedDate > $1.addedDate }) else {
            return []
        }
        return recent.map {
            .init(
                key: $0.key,
                title: $0.title ?? "",
                authorName: [$0.author ?? ""],
                subject: [$0.subject ?? ""],
                firstPublishYear: nil,
                coverI: Int($0.coverI),
                ratingsAverage: $0.rating,
                description: $0.description
            )
        }
    }
    
    init() {
        CoreDataService.shared.recentObservers.append {
            [weak self] in
            
            guard let self else { return }
            
            switchToTimePeriod(timePeriod, updateRecent: true)
        }
    }
    
    func didTapSeeMoreButton() {
        if let bookDataForWeek = self.bookData[.week] {
            let books = bookDataForWeek.1 // Получаем массив DocEntity для "этой недели"
            router?.navigateToBookListScreen(with: books, title: "Top Books")
        }
    }
    
    func activate() {
        // Загружаем данные для всех временных периодов один раз и сохраняем их
        let timePeriods: [BooksListRequest.Timeframe] = [.week, .month, .year]
        timePeriods.forEach { timePeriod in
            fetchBooksList(for: timePeriod) { [weak self] bookItems, docEntities in
                
                guard let self else { return }
                
                bookData[timePeriod] = (bookItems, docEntities)
                if timePeriod == .week { // Первоначальное отображение данных
                    view?.hideLoading()
                    view?.update(with: MainViewController.ViewModel(
                        topBooks: bookItems,
                        recentBooks: recentBooks,
                        books: docEntities
                    ), forTimePeriod: .week)
                }
            }
        }
    }
    
    func showBookDetail(for book: DocEntity) {
        router?.navigateToBookDetailScreen(with: book)
    }
    
    func switchToTimePeriod(_ timePeriod: BooksListRequest.Timeframe, updateRecent: Bool) {
        // Используем уже загруженные данные для обновления интерфейса
        if let data = bookData[timePeriod] {
            
            if updateRecent {
                self.view?.update(with: MainViewController.ViewModel(
                    topBooks: data.0,
                    recentBooks: recentBooks,
                    books: data.1
                ), forTimePeriod: timePeriod)
            } else {
                self.view?.update(with: MainViewController.ViewModel(
                    topBooks: data.0,
                    recentBooks: recentBooks,
                    books: data.1
                ), forTimePeriod: timePeriod, updateRecentBooks: false)
            }
        }
    }
    
    func fetchBooksList(for timePeriod: BooksListRequest.Timeframe, completion: @escaping ([MainViewController.ViewModel.BookItem], [DocEntity]) -> Void) {
        view?.showLoading()
        networkManager.sendRequest(request: BooksListRequest(timeframe: timePeriod)) { [weak self] result in
            switch result {
            case .success(let booksListEntity):
                let group = DispatchGroup()
                var bookItems: [MainViewController.ViewModel.BookItem] = []
                var docEntities: [DocEntity] = []
                
                let limitedWorks = Array(booksListEntity.works.prefix(10))
                limitedWorks.forEach { doc in
                    group.enter()
                    self?.fetchBookDetails(bookKey: doc.key) { category in
                        let bookItem = MainViewController.ViewModel.BookItem(
                            imageURL: doc.coverURL(),
                            category: category,
                            title: doc.title,
                            author: doc.authorName?.first
                        )
                        bookItems.append(bookItem)
                        let docEntity = DocEntity(
                            key: doc.key,
                            title: doc.title,
                            authorName: doc.authorName,
                            subject: category != nil ? [category!] : [],
                            firstPublishYear: doc.firstPublishYear,
                            coverI: doc.coverI,
                            coverId: doc.coverId,
                            ratingsAverage: doc.ratingsAverage,
                            description: doc.description
                        )
                        docEntities.append(docEntity)
                        group.leave()
                    }
                }
                
                group.notify(queue: .main) {
                    completion(bookItems, docEntities)
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
    
    func searchBooks(query: String) {
        view?.showLoading()
        let request = SearchBookRequest(query: query)
        networkManager.sendRequest(request: request) { [weak self] result in
            self?.view?.hideLoading()
            switch result {
            case .success(let response):
                self?.router?.navigateToSearchResultsScreen(with: response.docs)
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
