//
//  DocEntity.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 05.12.2023.
//

import Foundation

struct DocEntity: Decodable {
    
    enum CoverKey: String {
        case ISBN, OCLC, LCCN, OLID, ID
    }
    
    enum CoverSize: String {
        case S, M, L
    }
    
    let key: String
    let title: String
    let authorName: [String]?
    let subject: [String]?
    let firstPublishYear: Int?
    let coverI: Int?
    let ratingsAverage: Double?
    
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
