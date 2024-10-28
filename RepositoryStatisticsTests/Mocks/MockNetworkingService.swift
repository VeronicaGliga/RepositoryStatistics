//
//  MockNetworkProvider.swift
//  RepositoryStatisticsTests
//
//  Created by Veronica Gliga on 28.10.2024.
//

import Foundation
@testable import RepositoryStatistics

class MockNetworkingService<T: Endpoint>: NetworkingService<T> {
    override func request<U: Decodable>(_ request: T, for type: U.Type) async throws -> U {
        let url = baseURL.appendingPathComponent(request.path)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod.rawValue
        
        let (data, response) = try await session.data(for: urlRequest)
        
        // Check if the response is valid (status code 200-299)
        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            throw NetworkError.invalidResponse(statusCode: httpResponse.statusCode)
        }
        
        if data.isEmpty {
            throw NetworkError.noData
        }
        
        do {
            let decodedData = try JSONDecoder().decode(U.self, from: data)
            return decodedData
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}
