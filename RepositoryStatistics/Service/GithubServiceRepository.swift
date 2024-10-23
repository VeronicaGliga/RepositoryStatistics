//
//  GithubServiceRepository.swift
//  RepositoryStatistics
//
//  Created by Veronica Gliga on 23.10.2024.
//

import Foundation

class GithubServiceRepository: GithubService {
    func fetchPublicRepositories() async throws -> [Repository] {
        do {
            return try await networkProvider.request(.getRepositories, for: [Repository].self)
        } catch {
            throw error
        }
    }
}
