//
//  BooksListEntity.swift
//  BookstoreAppChallenge
//
//  Created by Nikita Shirobokov on 14.12.23.
//

import Foundation
import NetworkService
import Alamofire

struct BooksListEntity: Decodable {
    let docs: [DocsEntity]
}
