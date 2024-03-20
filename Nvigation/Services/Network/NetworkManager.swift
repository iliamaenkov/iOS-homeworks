//
//  NetworkManager.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 11.01.2024.
//

import Foundation

struct Response {
    let dataString: String
    let headers: [AnyHashable: Any]
    let statusCode: Int
}

struct NetworkManager {
    
    static func request(url: URL, completion: @escaping (Result<Response, Error>) -> Void) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data,
                  let dataString = String(data: data, encoding: .utf8),
                  let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            let headers = httpResponse.allHeaderFields
            let statusCode = httpResponse.statusCode
            let response = Response(dataString: dataString, headers: headers, statusCode: statusCode)
            
            completion(.success(response))
        }
        task.resume()
    }
}

enum AppConfiguration: String, CaseIterable {
    case people = "https://swapi.dev/api/people/8"
    case starships = "https://swapi.dev/api/starships/3"
    case planets = "https://swapi.dev/api/planets/5"
    
    var url: URL? {
        URL(string: self.rawValue)
    }
}

