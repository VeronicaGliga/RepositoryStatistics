//
//  Issue.swift
//  RepositoryStatistics
//
//  Created by Veronica Gliga on 22.10.2024.
//

import Foundation

struct Issue: Identifiable, Codable {
    let id: Int
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
    }
}
