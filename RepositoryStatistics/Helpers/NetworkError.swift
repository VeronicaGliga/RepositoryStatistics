//
//  NetworkError.swift
//  RepositoryStatistics
//
//  Created by Veronica Gliga on 23.10.2024.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse(statusCode: Int)
    case noData
    case decodingError(Error)
}
