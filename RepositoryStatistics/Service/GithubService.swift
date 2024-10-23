//
//  GithubService.swift
//  RepositoryStatistics
//
//  Created by Veronica Gliga on 22.10.2024.
//

import Foundation

class GithubService {
    func fetchPublicRepositories() async throws -> [Repository] {
            let url = URL(string: "https://api.github.com/repositories")!
            
            // Make a request to fetch repositories using async/await
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // Decode the data into an array of Repository
            let repositories = try JSONDecoder().decode([Repository].self, from: data)
            
            return repositories
        }
    
    func fetchIssues(for repository: String, owner: String) async throws -> [Issue] {
            let url = URL(string: "https://api.github.com/repos/\(owner)/\(repository)/issues?state=all&per_page=100")!
            
            let (data, _) = try await URLSession.shared.data(from: url)
            let issues = try JSONDecoder().decode([Issue].self, from: data)
            
            return issues
        }
}
