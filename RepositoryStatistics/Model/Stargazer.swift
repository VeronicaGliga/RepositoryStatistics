//
//  Stargazer.swift
//  RepositoryStatistics
//
//  Created by Veronica Gliga on 28.10.2024.
//

import Foundation

struct Stargazer: Decodable {
    let id: Int
    
    enum CodingKeys: CodingKey {
        case id
    }
}
