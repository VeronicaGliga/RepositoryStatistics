//
//  NetworkingService.swift
//  RepositoryStatistics
//
//  Created by Veronica Gliga on 23.10.2024.
//

import Foundation

class NetworkingService<T: Endpoint>: NetworkingServiceProtocol {
    // MARK: - Properties
    
    let baseURL: URL
    var session: URLSessionProtocol
    
    // MARK: - Init
    
    init(baseURL: URL, session: URLSessionProtocol = URLSession.shared) {
        self.baseURL = baseURL
        self.session = session
    }
    
    // MARK: - Function
    
    func request<U: Decodable>(_ request: T, for type: U.Type) async throws -> U {
        // Create the URL from baseURL and endpoint path
        let url = baseURL.appendingPathComponent(request.path)
        
        // Create the URLRequest object
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod.rawValue
        
        // Perform the network request asynchronously
        let (data, response) = try await session.data(for: urlRequest)
        
        // Check if the response is valid (status code 200-299)
        if let httpResponse = response as? HTTPURLResponse,
           !(200...299).contains(httpResponse.statusCode) {
            throw NetworkError.invalidResponse(statusCode: httpResponse.statusCode)
        }
        
        if data.isEmpty {
            throw NetworkError.noData
        }
        
        // Decode the response data into the expected type
        do {
            let decodedData = try JSONDecoder().decode(U.self, from: data)
            return decodedData
        } catch {
            print(error.localizedDescription)
            throw NetworkError.decodingError(error)
        }
    }
}
