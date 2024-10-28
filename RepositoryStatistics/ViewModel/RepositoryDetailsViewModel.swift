//
//  RepositoryDetailsViewModel.swift
//  RepositoryStatistics
//
//  Created by Veronica Gliga on 22.10.2024.
//

import Foundation

@MainActor
class RepositoryDetailViewModel: ObservableObject {
    // MARK: - Properties
    
    private let githubService: GithubServiceIssues
    
    @Published var openIssues = [GroupedIssue]()
    @Published var closedIssues = [GroupedIssue]()
    @Published var issues = [Issue]()
    @Published var errorMessage: String?
    @Published var stargazers = [Stargazer]()
    @Published var forks = [Fork]()
    
    // MARK: - Init
    
    init(githubService: GithubServiceIssues) {
        self.githubService = githubService
    }
    
    // MARK: - Functions
    
    func fetchRepositoryIssues(for repository: Repository) async {
        do {
            // Fetch issues from the GitHub service
            issues = try await githubService.fetchIssues(for: repository.name, owner: repository.owner.name)
            
            // Process and group issues by week
            splitAndGroupIssuesByWeek(issues: issues)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func fetchStargazers(for repository: Repository) async {
        do {
            stargazers = try await githubService.fetchStargazers(for: repository.name, owner: repository.owner.name)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func fetchForks(for repository: Repository) async {
        do {
            forks = try await githubService.fetchForks(for: repository.name, owner: repository.owner.name)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func splitAndGroupIssuesByWeek(issues: [Issue]) {
        let calendar = Calendar.current
        
        // Split issues into open and closed
        let open = issues.filter { $0.state == "open" }
        let closed = issues.filter { $0.state == "closed" }
        
        // Helper to group issues by week number
        func groupByWeek(issues: [Issue]) -> [GroupedIssue] {
            var groupedIssues = [Date: Int]()
            
            for issue in issues {
                if let date = issue.createdAt.toDate() {
                    if let weekStart = calendar.dateInterval(of: .weekOfYear, for: date)?.start {
                        groupedIssues[weekStart, default: 0] += 1
                    }
                }
            }
            
            return groupedIssues.map { weekStart, count in
                GroupedIssue(weekStart: weekStart, count: count)
            }.sorted { $0.weekStart < $1.weekStart }
        }
        
        // Group each set of issues by week
        openIssues = groupByWeek(issues: open)
        closedIssues = groupByWeek(issues: closed)
    }
}
