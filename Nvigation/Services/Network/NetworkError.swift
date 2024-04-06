//
//  NetworkError.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 16.01.2024.
//

import Foundation

enum NetworkError: Error, Equatable {
    case custom(description: String)
    case server
    case unknown
}
