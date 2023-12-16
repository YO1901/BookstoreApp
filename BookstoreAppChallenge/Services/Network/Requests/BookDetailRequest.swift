//
//  BookDetailRequest.swift
//  BookstoreAppChallenge
//
//  Created by Nikita Shirobokov on 16.12.23.
//

import Foundation
import NetworkService
import Alamofire

struct BookDetailRequest: NetworkRequest {
    typealias Response = BookDetailEntity
    
    let bookKey: String
    
    var url: URLConvertible {
        return "https://openlibrary.org\(bookKey).json"
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var parameters: Parameters {
        [:]
    }
}

struct BookDetailEntity: Decodable {
    let subjects: [String]?
}
