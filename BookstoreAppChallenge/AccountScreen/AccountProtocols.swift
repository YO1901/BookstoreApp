//
//  AccountProtocols.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 08.12.2023.
//

import Foundation

protocol AccountInput: AnyObject {
    func update(with model: AccountViewController.ViewModel)
    func showImagePicker()
}

protocol AccountOutput: AnyObject {
    func activate()
    func didTapAvatar()
    func didSelectAvatar(_ data: Data)
}
