//
//  BookEntity.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 05.12.2023.
//

import Foundation

struct BookEntity: Decodable {
    let title: String
    let key: String
    let description: Description?
    let covers: [Int]?
    let subjects: [String]?
    
    struct Description: Decodable {
        let value: String?
    }
}
