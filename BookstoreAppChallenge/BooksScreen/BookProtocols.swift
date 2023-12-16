//
//  BookProtocols.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 06.12.2023.
//

import Foundation

protocol BookInput: AnyObject {
    func update(with model: BookViewController.ViewModel)
    func showLoading()
    func hideLoading()
}

protocol BookOutput: AnyObject {
    func activate()
}
