//
//  Owner.swift
//  RepositoryStatistics
//
//  Created by Veronica Gliga on 22.10.2024.
//

import Foundation

struct Owner: Identifiable, Decodable {
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "login"
    }
    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        id = try container.decode(Int.self, forKey: .id)
//        name = try container.decode(String.self, forKey: .name)
//    }
}
