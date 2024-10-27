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
    
    @Published var issueCounts = [IssueCount]()
    @Published var issues = [Issue]()
    @Published var errorMessage: String?
    
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
            issueCounts = groupIssuesByWeek(issues)
        } catch {
            errorMessage = "Failed to load issues"
        }
    }
    
    // Group issues by week
    private func groupIssuesByWeek(_ issues: [Issue]) -> [IssueCount] {
        let calendar = Calendar.current
        let dateFormatter = ISO8601DateFormatter()
        var groupedIssues = [Date: [Issue]]()
        
        for issue in issues {
            if let createdAt = dateFormatter.date(from: issue.createdAt) {
                let weekStart = calendar.dateInterval(of: .weekOfYear, for: createdAt)!.start
                groupedIssues[weekStart, default: []].append(issue)
            }
        }
        
        // Convert the dictionary into an array of IssueCount
        let issueCounts = groupedIssues.map { (weekStart, issues) in
            IssueCount(weekStart: weekStart, count: Double(issues.count))
        }
        
        return issueCounts.sorted { $0.weekStart < $1.weekStart }
    }
}
