//
//  NetworkService.swift
//
//
//  Created by Victor on 04.12.2023.
//

import Foundation
import Alamofire

public enum NetworkError: Error {
    case networkError
    case decodingError
}

public final class NetworkManager {
    
    public init() { }
    
    public func sendRequest<Request>(request: Request, completionHandler: @escaping (Result<Request.Response, Error>) -> Void) where Request: NetworkRequest {
        AF.request(
            request.url,
            method: request.method,
            parameters: request.parameters,
            encoding: request.encoding
        ).response {
            dataResponse in
            
            guard let data = dataResponse.data else {
                completionHandler(.failure(NetworkError.networkError))
                return
            }
            
            guard let decoded = try? request.decoder.decode(Request.Response.self, from: data) else {
                completionHandler(.failure(NetworkError.decodingError))
                return
            }
            
            completionHandler(.success(decoded))
        }
    }
}
