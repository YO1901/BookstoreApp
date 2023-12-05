//
//  NetworkRequest.swift
//
//
//  Created by Victor on 04.12.2023.
//

import Foundation
import Alamofire

public protocol NetworkRequest {
    
    associatedtype Response: Decodable
    
    var url: URLConvertible { get }
    var method: HTTPMethod { get }
    var parameters: Parameters { get }
    var encoding: ParameterEncoding { get }
    var decoder: DataDecoder { get }
}

public extension NetworkRequest {
    var encoding: ParameterEncoding {
        URLEncoding()
    }
    
    var decoder: DataDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
