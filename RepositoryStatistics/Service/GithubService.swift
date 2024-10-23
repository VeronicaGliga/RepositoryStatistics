//
//  GithubService.swift
//  RepositoryStatistics
//
//  Created by Veronica Gliga on 22.10.2024.
//

import Foundation

class GithubService {
    // MARK: - Properties
    
    let networkProvider: NetworkingService<ApiTarget>
    
    // MARK: - Init
    
    init(networkProvider: NetworkingService<ApiTarget>) {
        self.networkProvider = networkProvider
    }
}
