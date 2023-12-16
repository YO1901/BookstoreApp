//
//  CategoriesProtocols.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 16.12.2023.
//

import Foundation

protocol CategoriesScreenInput: AnyObject {
    func updateUI()
}

protocol CategoriesScreenOutput: AnyObject {
    
    var items: [CategoriesViewController.Category] { get }
    
    func activate()
}
