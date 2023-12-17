//
//  SearchBooksEntity.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 05.12.2023.
//

import Foundation
import NetworkService
import Alamofire

struct SearchBooksEntity: Decodable {    
    let docs: [DocEntity]
}
