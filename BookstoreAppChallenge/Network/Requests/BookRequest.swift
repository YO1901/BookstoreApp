//
//  BookRequest.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 05.12.2023.
//

import Foundation
import NetworkService
import Alamofire

struct BookRequest: NetworkRequest {
    typealias Response = BookEntity
    
    let key: String
    
    var url: Alamofire.URLConvertible {
        "https://openlibrary.org\(key).json"
    }
    
    var method: Alamofire.HTTPMethod {
        .get
    }
    
    var parameters: Alamofire.Parameters {
        [:]
    }
    
    init(key: String) {
        self.key = key
    }
}
