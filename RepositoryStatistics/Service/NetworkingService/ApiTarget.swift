//
//  ApiTarget.swift
//  RepositoryStatistics
//
//  Created by Veronica Gliga on 23.10.2024.
//

import Foundation

enum HTTPMethod: String {
    case get
    case post
    case put
    case patch
    case delete
}

enum ApiTarget {
    case getRepositories
    case getRepositoryIssues(owner: String, repository: String)
}

extension ApiTarget: Endpoint {
    var path: String {
        switch self {
        case .getRepositories:
            return "/repositories"
        case .getRepositoryIssues(let owner, let repository):
            return "/repos/\(owner)/\(repository)/issues"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
}
