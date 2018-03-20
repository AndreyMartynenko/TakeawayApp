//
//  GenericClient.swift
//  TakeawayApp
//
//  Created by Andrey on 3/19/18.
//

import Foundation

protocol Gettable {
    associatedtype T
    
    func retrieve(completion: @escaping (Result<T?, ClientError>) -> Void)
}

protocol GenericClient {
    
    func fetch<T: Decodable>(fileName: String, decode: @escaping (Decodable) -> T?, completion: @escaping (Result<T, ClientError>) -> Void)
    
}

extension GenericClient {
    
    typealias JSONTaskCompletionHandler = (Decodable?, ClientError?) -> Void
    
    func fetch<T: Decodable>(fileName: String, decode: @escaping (Decodable) -> T?, completion: @escaping (Result<T, ClientError>) -> Void) {
        
        decodeJson(fileName: fileName, decodingType: T.self) { (json, error) in
            
            guard let json = json else {
                if let error = error {
                    completion(Result.failure(error))
                } else {
                    completion(Result.failure(.invalidData))
                }
                return
            }
            
            if let value = decode(json) {
                completion(.success(value))
            } else {
                completion(.failure(.jsonParsingFailure))
            }

        }
    }
    
    fileprivate func decodeJson<T: Decodable>(fileName: String, decodingType: T.Type, completionHandler completion: @escaping JSONTaskCompletionHandler) {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
            completion(nil, .jsonInvalidPath)
            return
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let genericModel = try JSONDecoder().decode(decodingType, from: data)
            completion(genericModel, nil)
        } catch {
            completion(nil, .jsonConversionFailure)
        }
    }
    
}
