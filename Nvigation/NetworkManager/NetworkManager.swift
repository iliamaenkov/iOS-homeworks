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
    
    static func request(for configuration: AppConfiguration, completion: @escaping (Result<Response, Error>) -> Void) {
        let url = configuration.url
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

enum AppConfiguration {
    
    case people(URL)
    case starships(URL)
    case planets(URL)
    
    var url: URL {
        switch self {
        case .people(let url), .starships(let url), .planets(let url):
            return url
        }
    }
}

