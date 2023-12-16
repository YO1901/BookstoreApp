//
//  BooksListRequest.swift
//  BookstoreAppChallenge
//
//  Created by Nikita Shirobokov on 14.12.23.
//

import Foundation
import NetworkService
import Alamofire

struct BooksListRequest: NetworkRequest {
    typealias Response = BooksListEntity
        
        let timeframe: Timeframe
        
        var url: URLConvertible {
            return "https://openlibrary.org/trending/\(timeframe.rawValue).json"
        }
    
    var method: Alamofire.HTTPMethod {
        .get
    }
    
    var parameters: Alamofire.Parameters {
        [:]
    }
}

extension BooksListRequest {
    enum Timeframe: String {
        case week = "week"
        case month = "month"
        case year = "year"
    }
}
