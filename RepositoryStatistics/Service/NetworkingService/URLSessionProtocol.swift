//
//  NetworkProviderProtocol.swift
//  RepositoryStatistics
//
//  Created by Veronica Gliga on 28.10.2024.
//

import Foundation

protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
