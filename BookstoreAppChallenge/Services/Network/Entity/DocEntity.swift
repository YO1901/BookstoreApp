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
    let coverId: Int?
    let ratingsAverage: Double?
    let description: String?
    
    init(
        key: String,
        title: String,
        authorName: [String]?,
        subject: [String]?,
        firstPublishYear: Int?,
        coverI: Int?,
        coverId: Int? = nil,
        ratingsAverage: Double?,
        description: String?
    ) {
        self.key = key
        self.title = title
        self.authorName = authorName
        self.subject = subject
        self.firstPublishYear = firstPublishYear
        self.coverI = coverI
        self.coverId = coverId
        self.ratingsAverage = ratingsAverage
        self.description = description
    }
    
    func coverURL(coverKey: CoverKey = .ID, coverSize: CoverSize = .M) -> URL? {
        guard let cover, let url = URL(string: "https://covers.openlibrary.org/b/\(coverKey)/\(cover)-\(coverSize).jpg") else {
            return nil
        }
        return url
    }
    
    var readURL: URL? {
        URL(string: "https://openlibrary.org\(key)")
    }
    
    var cover: Int? {
        coverI ?? coverId
    }
}
