//
//  DocsEntity.swift
//  BookstoreAppChallenge
//
//  Created by Nikita Shirobokov on 16.12.23.
//

import Foundation

import Foundation

struct DocsEntity: Decodable {
    
    enum CoverKey: String {
        case ISBN, OCLC, LCCN, OLID, ID
    }
    
    enum CoverSize: String {
        case S, M, L
    }
    
    let key: String
    let title: String
    let editionCount: Int
    let firstPublishYear: Int?
    let hasFulltext: Bool
    let coverI: Int?
    let language: [String]?
    let authorName: [String]?
    let subject: [String]?
    let coverEditionKey: String?
    let averageRating: Double?
    
    func coverURL(coverKey: CoverKey = .ID, coverSize: CoverSize = .M) -> URL? {
        guard let coverI, let url = URL(string: "https://covers.openlibrary.org/b/\(coverKey)/\(coverI)-\(coverSize).jpg") else {
            return nil
        }
        return url
    }
    
    var readURL: URL? {
        URL(string: "https://openlibrary.org\(key)")
    }
}

