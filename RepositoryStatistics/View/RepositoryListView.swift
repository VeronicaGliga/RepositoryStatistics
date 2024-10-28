//
//  RepositoryListView.swift
//  RepositoryStatistics
//
//  Created by Veronica Gliga on 22.10.2024.
//

import SwiftUI

struct RepositoryListView: View {
    // MARK: - Properties
    
    @StateObject private var viewModel = RepositoryListViewModel(githubService: GithubServiceRepository(networkProvider: NetworkingService(baseURL: URL(string: "https://api.github.com")!)))
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.repositories.isEmpty {
                    VStack {
                        Text("No repositories available")
                            .font(.title2)
                            .foregroundColor(.gray)
                            .padding()
                        Spacer()
                    }
                } else {
                    List(viewModel.repositories) { repo in
                        NavigationLink(destination: RepositoryDetailsView(repository: repo)) {
                            RepositoryRowView(repository: repo)
                        }
                    }
                }
            }
            .navigationTitle("GitHub Repositories")
            .task {
                await viewModel.fetchRepositories()
            }
            .alert(isPresented: .constant(viewModel.errorMessage != nil)) {
                Alert(title: Text("Error"), 
                      message: Text(viewModel.errorMessage ?? ""),
                      dismissButton: .default(Text("OK")))
            }
        }
    }
}

// MARK: - RepositoryRowView

struct RepositoryRowView: View {
    let repository: Repository
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(repository.name)
                .font(.headline)
            Text(repository.description ?? "No description available")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    RepositoryListView()
}
