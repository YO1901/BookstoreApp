//
//  ListsProtocols.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 14.12.2023.
//

import UIKit

protocol ListsViewInput: AnyObject {
    func update(with model: ListsViewController.ViewModel)
    func openNewListDialog()
    func deleteItem(at: Int)
}

protocol ListsViewOutput: AnyObject {
    func activate()
    func didTapPlusButton()
    func didEnterNewList(_ title: String?)
    func deleteList(_ title: String, _ index: Int)
}
