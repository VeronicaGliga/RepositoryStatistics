//
//  ApiTarget.swift
//  RepositoryStatistics
//
//  Created by Veronica Gliga on 23.10.2024.
//

import Foundation

enum ApiTarget {
    case getRepositories
    case getRepositoryIssues(owner: String, repository: String)
    case getRepositoryStargazers(owner: String, repository: String)
    case getRepositoryForks(owner: String, repository: String)
}

extension ApiTarget: Endpoint {
    var path: String {
        switch self {
        case .getRepositories:
            return "/repositories"
        case .getRepositoryIssues(let owner, let repository):
            return "/repos/\(owner)/\(repository)/issues"
        case .getRepositoryStargazers(let owner, let repository):
            return "/repos/\(owner)/\(repository)/stargazers"
        case .getRepositoryForks(let owner, let repository):
            return "/repos/\(owner)/\(repository)/forks"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
}
