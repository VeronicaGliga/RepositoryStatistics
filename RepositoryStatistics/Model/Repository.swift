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
    
//    init(id: Int, name: String, owner: Owner, description: String, starGazers_count: Int, forks_count: Int, url: String) {
//        self.id = id
//        self.name = name
//        self.owner = owner
//        self.description = description
//        self.stargazers_count = starGazers_count
//        self.forks_count = forks_count
//        self.url = url
//    }
    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        
//        id = try container.decode(Int.self, forKey: .id)
//        name = try container.decode(String.self, forKey: .name)
//        owner = try container.decode(Owner.self, forKey: .owner)
//        description = try container.decode(String.self, forKey: .description)
//        stargazersCount = try container.decode(Int.self, forKey: .stargazersCount)
//        forksCount = try container.decode(Int.self, forKey: .forksCount)
//        url = try container.decode(String.self, forKey: .url)
//    }
}
