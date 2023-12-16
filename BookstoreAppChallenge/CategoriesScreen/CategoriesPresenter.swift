//
//  CategoriesPresenter.swift
//  BookstoreAppChallenge
//
//  Created by Victor Rubenko on 16.12.2023.
//

import Foundation

final class CategoriesPresenter: CategoriesScreenOutput {
    
    var items: [CategoriesViewController.Category] {
        SubjectRequest.Subject.allCases.map {
            subject in
            
            .init(
                title: subject.rawValue,
                didSelectHandler: {
                    [weak self] in
                    
                    self?.router?.openListBookScreen(subject)
                }
            )
        }
    }
    
    
    weak var view: CategoriesScreenInput?
    var router: CategoriesRouter?
    
    func activate() {
        
    }
}
