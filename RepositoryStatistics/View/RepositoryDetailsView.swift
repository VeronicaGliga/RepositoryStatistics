//
//  RepositoryDetailsView.swift
//  RepositoryStatistics
//
//  Created by Veronica Gliga on 22.10.2024.
//

import SwiftUI
import Charts

struct RepositoryDetailsView: View {
    let repository: Repository
        @StateObject private var viewModel = RepositoryDetailViewModel(githubService: GithubService())
        
        var body: some View {
            VStack {
                // Display key repository statistics
                VStack(alignment: .leading, spacing: 10) {
                    Text("⭐️ Stars: \(repository.stargazersCount ?? 0)")
                    Text("🍴 Forks: \(repository.forksCount ?? 0)")
                    Text("🐞 Open Issues: \(viewModel.issues.count)")
                }
                .padding()
                
                // Chart for issue history
                if viewModel.issueCounts.isEmpty {
                    Text("Loading issue data...")
                        .onAppear {
                            Task {
                                await viewModel.fetchRepositoryIssues(for: repository)
                            }
                        }
                } else {
                    let maxYValue = (viewModel.issueCounts.map { $0.count }.max() ?? 10) + 5 // Set a buffer
                    Chart(viewModel.issueCounts) { issueCount in
                        LineMark(
                            x: .value("Week", issueCount.weekStart),
                            y: .value("Issues", issueCount.count)
                        )
                    }
                    .chartYAxisLabel("Number of Issues")
                    .chartXAxisLabel("Weeks")
                    .chartYScale(domain: 0...maxYValue) // Dynamic Y-scale
                    .frame(height: 300)
                    .padding()
                }
            }
            .navigationTitle(repository.name)
            .alert(isPresented: .constant(viewModel.errorMessage != nil)) {
                Alert(title: Text("Error"), message: Text(viewModel.errorMessage ?? ""), dismissButton: .default(Text("OK")))
            }
        }
}

#Preview {
    RepositoryDetailsView(repository: Repository(id: 1, name: "Test Name", owner: Owner(id: 1, name: "Test Name"), description: "Test Description", stargazersCount: 2, forksCount: 3, url: ""))
}
