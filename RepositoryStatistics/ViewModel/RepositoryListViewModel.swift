//
//  RepositoryListViewModel.swift
//  RepositoryStatistics
//
//  Created by Veronica Gliga on 22.10.2024.
//

import Foundation

@MainActor
class RepositoryListViewModel: ObservableObject {
    // Published variable to store repositories
    @Published var repositories: [Repository] = []
    
    // Error handling
    @Published var errorMessage: String? = nil
    
    private let githubService: GithubServiceRepository
    
    init(githubService: GithubServiceRepository) {
        self.githubService = githubService
    }
    
    // Fetch repositories from the service
    func fetchRepositories() async {
        do {
            // Fetch repositories from the GitHub service
            self.repositories = try await githubService.fetchPublicRepositories()
        } catch {
            // Handle error
            self.errorMessage = "Failed to load repositories"
        }
    }
}
