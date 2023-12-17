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
            
            do {
                let decoded = try request.decoder.decode(Request.Response.self, from: data)
                completionHandler(.success(decoded))
            } catch DecodingError.keyNotFound(let key, _) {
                print("Отсутствует ключ: \(key.stringValue)")
                // Можно обработать этот случай специально, например, возвращать частично заполненный объект или ошибку
                completionHandler(.failure(NetworkError.decodingError))
            } catch {
                print("Decoding error: \(error)")
                completionHandler(.failure(NetworkError.decodingError))
            }
            
//            completionHandler(.success(decoded))
        }
    }
}
