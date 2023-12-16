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
    let description: String?
    let covers: [Int]?
    let subjects: [String]?
    
    enum CodingKeys: String, CodingKey {
        case title, key, description, covers, subjects
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        key = try container.decode(String.self, forKey: .key)
        covers = try container.decode([Int].self, forKey: .covers)
        subjects = try container.decode([String].self, forKey: .subjects)
        do {
            let desc = try container.decode(Description.self, forKey: .description)
            description = desc.value
        } catch DecodingError.typeMismatch {
            description = try container.decode(String.self, forKey: .description)
        }
    }
    
    struct Description: Decodable {
        let value: String?
    }
}
