//
//  DataStructures.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 16.01.2024.
//

import Foundation

struct UserInfo: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
}


struct Planet: Decodable {
    let name: String
    let orbitalPeriod: String
    let residents: [String]
    var residentsData: [Resident]?

    enum CodingKeys: String, CodingKey {
        case name
        case residents
        case orbitalPeriod = "orbital_period"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        residents = try container.decode([String].self, forKey: .residents)
        orbitalPeriod = try container.decode(String.self, forKey: .orbitalPeriod)
    }
}

struct Resident: Decodable {
    let name: String

    enum CodingKeys: String, CodingKey {
        case name
    }
}
