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

//class MockNetworkingService<T: Endpoint>: NetworkingService<T> {
//    var result: Result<Data, Error>?
//    
//    func request<U: Decodable>(_ endpoint: MockEndpoint, for type: U.Type) async throws -> U {
//        // Check if there's a predefined result
//        guard let result = result else {
//            fatalError("MockNetworkingService result not set")
//        }
//        
//        switch result {
//        case .success(let data):
//            do {
//                // Decode the data to the expected type and return it
//                let decodedData = try JSONDecoder().decode(U.self, from: data)
//                return decodedData
//            } catch {
//                throw NetworkError.decodingError(error)
//            }
//            
//        case .failure(let error):
//            // Throw the predefined error
//            throw error
//        }
//    }
//}
