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
    
    func fetchStargazers(for repository: String, owner: String) async throws -> [Stargazer] {
        do {
            return try await networkProvider.request(.getRepositoryStargazers(owner: owner, repository: repository), for: [Stargazer].self)
        } catch {
            throw error
        }
    }
    
    func fetchForks(for repository: String, owner: String) async throws -> [Fork] {
        do {
            return try await networkProvider.request(.getRepositoryStargazers(owner: owner, repository: repository), for: [Fork].self)
        } catch {
            throw error
        }
    }
}
