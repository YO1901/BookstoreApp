//
//  SubjectEntity.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 05.12.2023.
//

import Foundation

struct SubjectEntity: Decodable {
    let name: String
    let works: [DocEntity]
}
