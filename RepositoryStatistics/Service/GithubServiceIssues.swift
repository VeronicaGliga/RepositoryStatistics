//
//  GithubServiceIssues.swift
//  RepositoryStatistics
//
//  Created by Veronica Gliga on 23.10.2024.
//

import Foundation

class GithubServiceIssues: GithubService {
    func fetchIssues(for repository: String, owner: String) async throws -> [Issue] {
        do {
            return try await networkProvider.request(.getRepositoryIssues(owner: owner, repository: repository), for: [Issue].self)
        } catch {
            throw error
        }
    }
}
