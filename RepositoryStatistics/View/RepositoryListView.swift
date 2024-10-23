//
//  RepositoryListView.swift
//  RepositoryStatistics
//
//  Created by Veronica Gliga on 22.10.2024.
//

import SwiftUI

struct RepositoryListView: View {
    // ViewModel instance
    @StateObject private var viewModel = RepositoryListViewModel(githubService: GithubServiceRepository(networkProvider: NetworkingService(baseURL: URL(string: "https://api.github.com")!)))
    
    var body: some View {
        NavigationView {
            List(viewModel.repositories) { repo in
                NavigationLink(destination: RepositoryDetailsView(repository: repo)) {
                    RepositoryRowView(repository: repo) // Custom row view for each repo
                }
            }
            .navigationTitle("GitHub Repositories")
            .task {
                // Call the async function to load repositories
                await viewModel.fetchRepositories()
            }
            .alert(isPresented: .constant(viewModel.errorMessage != nil)) {
                Alert(title: Text("Error"), message: Text(viewModel.errorMessage ?? ""), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct RepositoryRowView: View {
    let repository: Repository
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(repository.name)
                .font(.headline)
            Text(repository.description ?? "No description available")
                .font(.subheadline)
                .foregroundColor(.secondary)
            HStack {
                Text("⭐️ \(repository.stargazersCount ?? 0)")
                Text("🍴 \(repository.forksCount ?? 0)")
            }
            .font(.footnote)
            .foregroundColor(.secondary)
        }
    }
}

#Preview {
    RepositoryListView()
}
