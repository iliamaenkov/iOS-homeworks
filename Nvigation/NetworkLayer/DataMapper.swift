//
//  DataMapper.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 18.01.2024.
//

import Foundation

final class DataMapper {
    static func map<T: Decodable>(_ type: T.Type, from data: Data, completion: @escaping (Result<T, NetworkError>) -> Void) {
        DispatchQueue.global().async {
            do {
                let model = try JSONDecoder().decode(type, from: data)
                DispatchQueue.main.async {
                    completion(.success(model))
                }
            } catch {
                print("Error decoding JSON: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.custom(description: error.localizedDescription)))
                }
            }
        }
    }
}
