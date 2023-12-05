//
//  ConfigureProtocol.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 06.12.2023.
//

import Foundation

protocol Configurable {
    associatedtype Model
    
    func update(model: Model)
}
