//
//  Repository.swift
//  RepositoryStatistics
//
//  Created by Veronica Gliga on 22.10.2024.
//

import Foundation

struct Repository: Identifiable, Decodable {
    let id: Int
    let name: String
    let owner: Owner
    let description: String?
    let stargazersCount: Int?
    let forksCount: Int?
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case owner
        case description
        case stargazersCount = "stargazers_count"
        case forksCount = "forks_count"
        case url = "html_url"
    }
}
