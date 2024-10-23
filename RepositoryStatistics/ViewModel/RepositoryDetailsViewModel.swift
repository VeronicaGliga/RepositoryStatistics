//
//  RepositoryDetailsViewModel.swift
//  RepositoryStatistics
//
//  Created by Veronica Gliga on 22.10.2024.
//

import Foundation

@MainActor
class RepositoryDetailViewModel: ObservableObject {
    @Published var issueCounts: [IssueCount] = []
    @Published var issues = [Issue]()
    @Published var errorMessage: String? = nil
    
    let githubService: GithubServiceIssues
    
    init(githubService: GithubServiceIssues) {
        self.githubService = githubService
    }
    
    struct IssueCount: Identifiable {
        var id = UUID()
        let weekStart: Date
        let count: Int
    }
    
    func fetchRepositoryIssues(for repository: Repository) async {
        do {
            // Fetch issues from the GitHub service
            self.issues = try await githubService.fetchIssues(for: repository.name, owner: repository.owner.name)
            
            // Process and group issues by week
            self.issueCounts = self.groupIssuesByWeek(self.issues)
        } catch {
            self.errorMessage = "Failed to load issues"
        }
    }
    
    // Group issues by week
    private func groupIssuesByWeek(_ issues: [Issue]) -> [IssueCount] {
        let calendar = Calendar.current
        
        // Create a date formatter to parse issue creation dates
        let dateFormatter = ISO8601DateFormatter()
        
        // Group issues by start of the week (Sunday)
        var groupedIssues: [Date: [Issue]] = [:]
        
        for issue in issues {
            if let createdAt = dateFormatter.date(from: issue.createdAt) {
                let weekStart = calendar.dateInterval(of: .weekOfYear, for: createdAt)!.start
                groupedIssues[weekStart, default: []].append(issue)
            }
        }
        
        // Convert the dictionary into an array of IssueCount
        let issueCounts = groupedIssues.map { (weekStart, issues) in
            IssueCount(weekStart: weekStart, count: issues.count)
        }
        
        return issueCounts.sorted(by: { $0.weekStart < $1.weekStart })
    }
}
