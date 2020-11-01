//
//  Connection.swift
//  Geopago Challenge
//
//  Created by Lion User on 11/08/2020.
//  Copyright © 2020 Risso Pablo. All rights reserved.
//

import UIKit
import Combine

enum ConnectionError : Error {
    case couldntDecode(info: Error)
    case notFound
    case wrongURL
}

class Resources: ResourcesService {
    
    func getData<T : Decodable>(url urlStr: String) -> AnyPublisher<T, ConnectionError> {
        
        guard let url = URL(string: urlStr) else {
            return Result.Publisher(.failure(.wrongURL)).eraseToAnyPublisher()
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .mapError { (error) -> ConnectionError in
                return ConnectionError.notFound
            }
            .map(\.data)
            .receive(on: DispatchQueue.global())
            .decode(type: T.self, decoder: decoder)
            .mapError { (error) -> ConnectionError in
                return ConnectionError.couldntDecode(info: error)
            }
            .eraseToAnyPublisher()
    }
    
    func loadImage(url urlStr: String) -> AnyPublisher<UIImage?, ConnectionError> {
        guard let url = URL(string: urlStr) else {
            return Result.Publisher(.failure(.wrongURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .mapError {(error) -> ConnectionError in
                return ConnectionError.notFound }
            .map { (data, response) -> UIImage? in
            return UIImage(data: data) }
            .catch { error in
                return Result.Publisher(nil) }
            .eraseToAnyPublisher()
    }
}
