//
//  SearchBooksRequest.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 05.12.2023.
//

import Foundation
import NetworkService
import Alamofire

struct SearchBookRequest: NetworkRequest {
    
    typealias Response = SearchBooksEntity
    
    enum SortKey: String {
        case rating
        case wantToRead = "want_to_read"
        case new
    }
    
    var url: Alamofire.URLConvertible {
        "https://openlibrary.org/search.json?q=\(query)"
    }
    
    var method: Alamofire.HTTPMethod {
        .get
    }
    
//    var parameters: Alamofire.Parameters {
//        var params: [String : Any] = [
//            "q=": query.replacingOccurrences(of: " ", with: "+"),
//            "fields": "title,author_name,subject,cover_i,first_publish_year",
//            "limit": limit
//        ]
//        if let sort {
//            params["sort"] = sort.rawValue
//        }
//        return params
//    }
    var parameters: Alamofire.Parameters {
       [:]
    }
    
    let query: String
    let sort: SortKey?
    let limit: Int
    
    
    init(
        query: String,
        sort: SortKey? = nil,
        limit: Int = 0
    ) {
        self.query = query
        self.sort = sort
        self.limit = limit
    }
}
