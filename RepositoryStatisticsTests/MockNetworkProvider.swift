//
//  MockNetworkProvider.swift
//  RepositoryStatisticsTests
//
//  Created by Veronica Gliga on 28.10.2024.
//

import Foundation
@testable import RepositoryStatistics

class MockURLSession: URLSessionProtocol {
    var dataToReturn: Data?
    var responseToReturn: URLResponse?
    var statusCodeToReturn = 200
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        (dataToReturn ?? Data(), responseToReturn ?? HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
    }
}

struct MockEndpoint: Endpoint {
    var path: String
    var httpMethod: HTTPMethod
}

class MockNetworkingService<T: Endpoint>: NetworkingService<T> {
    var result: Any?
    
    override func request<U>(_ request: T, for type: U.Type) async throws -> U where U: Decodable {
        guard let result = result as? U else { throw NetworkError.decodingError(NSError()) }
        return result
    }
}
