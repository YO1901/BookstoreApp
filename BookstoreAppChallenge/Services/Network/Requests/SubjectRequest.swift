//
//  SubjectRequest.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 05.12.2023.
//

import Foundation
import NetworkService
import Alamofire

struct SubjectRequest: NetworkRequest {
    typealias Response = SubjectEntity
    
    let subject: Subject
    
    var url: Alamofire.URLConvertible {
        "https://openlibrary.org/subjects/\(subject.rawValue.lowercased()).json"
    }
    
    var method: Alamofire.HTTPMethod {
        .get
    }
    
    var parameters: Alamofire.Parameters {
        [:]
    }
    
    init(subject: Subject) {
        self.subject = subject
    }
}

extension SubjectRequest {
    enum Subject: String, CaseIterable {
        case Fantasy
        case Horror
        case Humor
        case Literature
        case Poetry
        case Romance
        case ScienceFiction = "Science Fiction"
        case Thriller
        case Magic
        case HistoricalFiction = "Historical Fiction"
    }
}
