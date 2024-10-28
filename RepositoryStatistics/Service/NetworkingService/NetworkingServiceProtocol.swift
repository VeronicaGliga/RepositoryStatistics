//
//  NetworkingServiceProtocol.swift
//  RepositoryStatistics
//
//  Created by Veronica Gliga on 28.10.2024.
//

import Foundation

protocol NetworkingServiceProtocol {
    associatedtype EndpointType: Endpoint
    
    /// Makes a network request to the given endpoint and returns a decoded response of the specified type.
    ///
    /// - Parameters:
    ///   - endpoint: The endpoint to be requested, conforming to the `Endpoint` protocol.
    ///   - type: The expected type of the response, which must conform to `Decodable`.
    /// - Returns: A decoded response of type `U` if the request and decoding are successful.
    /// - Throws: An error if the request fails or the response cannot be decoded.
    func request<U: Decodable>(_ request: EndpointType, for type: U.Type) async throws -> U
}
