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
    let state: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case state
    }
    
    func dateFromString() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.date(from: createdAt)
    }
}
