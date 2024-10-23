//
//  RepositoryListViewModel.swift
//  RepositoryStatistics
//
//  Created by Veronica Gliga on 22.10.2024.
//

import Foundation

@MainActor
class RepositoryListViewModel: ObservableObject {
    // MARK: - Properties
    
    private let githubService: GithubServiceRepository
    
    @Published var repositories = [Repository]()
    @Published var errorMessage: String?
    
    // MARK: - Init
    
    init(githubService: GithubServiceRepository) {
        self.githubService = githubService
    }
    
    // MARK: - Functions
    
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
