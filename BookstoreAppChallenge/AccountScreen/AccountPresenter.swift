//
//  AccountPresenter.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 08.12.2023.
//

import UIKit

final class AccountPresenter: AccountOutput {
    
    var router: AccountRouter?
    weak var view: AccountInput?
    
    private var name: String {
        UserDefaultsService.shared.userName
    }
    
    func activate() {
        
        if let image = UIImage(named: "example.png") {
            if let data = image.pngData() {
                let filename = getDocumentsDirectory().appendingPathComponent("copy.png")
                try? data.write(to: filename)
            }
        }
        
        view?.update(
            with: .init(
                image: getSavedImage(),
                name: name,
                didChangeName: {
                    name in
                    
                    UserDefaultsService.shared.userName = name
                },
                didTapListButton: {
                    [weak self] in
                    
                    self?.router?.openListsScreen()
                }
            )
        )
    }
    
    func didTapAvatar() {
        view?.showImagePicker()
    }
    
    func didSelectAvatar(_ data: Data) {
        let filename = getDocumentsDirectory().appendingPathComponent("avatar.jpg")
        try? data.write(to: filename)
        view?.update(
            with: .init(
                image: data,
                name: name,
                didChangeName: {
                    name in
                    
                    UserDefaultsService.shared.userName = name
                },
                didTapListButton: {
                    [weak self] in
                    
                    self?.router?.openListsScreen()
                }
            )
        )
    }
    
    private func getSavedImage() -> Data? {
        let filename = getDocumentsDirectory().appendingPathComponent("avatar.jpg")
        return try? Data(contentsOf: filename)
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
