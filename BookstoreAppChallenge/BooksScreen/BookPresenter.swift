//
//  BookPresenter.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 06.12.2023.
//

import Foundation
import UIKit
import NetworkService

final class BookPresenter: BookOutput {
    
    var router: BookRouter?
    weak var view: BookInput?
    
    private let doc: DocEntity
    private let networkManager = NetworkManager()
    
    init(_ doc: DocEntity) {
        self.doc = doc
    }
    
    func activate() {
        networkManager.sendRequest(request: BookRequest(key: doc.key)) {
            [weak self] result in
            
            guard let self else {
                return
            }
            
            switch result {
            case .success(let book):
                
                let rating: String? = {
                    guard let ratings = self.doc.ratingsAverage else {
                        return nil
                    }
                    return "\(Double(Int(ratings * 100)) / 100) / 5"
                }()
                
                view?.update(
                    with: .init(
                        title: doc.title,
                        category: doc.subject?.first,
                        header: .init(
                            imageURL: doc.coverURL(),
                            author: doc.authorName?.first,
                            category: doc.subject?.first,
                            rating: rating,
                            addToListClosure: {
                                print("add to list")
                            },
                            readClosure: {
                                [weak self] in
                                
                                guard let self else { return }
                                guard let url = doc.readURL else {
                                    return
                                }
                                UIApplication.shared.open(url)
                            }
                        ),
                        description: book.description?.value ?? "",
                        likeBarButtonAction: {
                            print("like")
                        }
                    )
                )
            case .failure(let error):
                print(error)
            }
        }
    }
}
