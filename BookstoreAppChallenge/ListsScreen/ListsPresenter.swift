//
//  ListsPresenter.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 14.12.2023.
//

import Foundation

final class ListsPresenter: ListsViewOutput {
    
    typealias ViewModel = ListsViewController.ViewModel
    
    weak var view: ListsViewInput?
    var router: ListsRouter?
    
    private var lists = [OpenBookList]()
    private var selectListClosure: ((String) -> Void)?
    
    init(_ selectListClosure: ((String) -> Void)? = nil) {
        self.selectListClosure = selectListClosure
    }
    
    func activate() {
        loadData()
    }
    
    func didTapPlusButton() {
        view?.openNewListDialog()
    }
    
    func didEnterNewList(_ title: String?) {
        guard let title else {
            return
        }
        if CoreDataService.shared.createNewList(title: title) {
            loadData()
        }
    }
    
    private func loadData() {
        var items = [ViewModel.Item]()
        lists = CoreDataService.shared.getLists().filter { $0.title != "Recent" }
        lists.enumerated().forEach {
            index, list in
            
            guard let title = list.title else {
                return
            }
            items.append(
                .list(title: title) {
                    [weak self] in
                    
                    guard let self else { return }
                    
                    if let selectListClosure {
                        selectListClosure(title)
                    } else {
                        router?.openListScreen(listName: title)
                    }
                }
            )
            if index != lists.count - 1 {
                items.append(.space(height: 25))
            }
        }
        
        view?.update(with: .init(items: items))
    }
    
    func deleteList(_ title: String, _ index: Int) {
        if CoreDataService.shared.deleteList(title: title) {
            view?.deleteItem(at: index)
        }
    }
}
