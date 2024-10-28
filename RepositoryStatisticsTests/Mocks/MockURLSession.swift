//
//  MockURLSession.swift
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
