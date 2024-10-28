//
//  NetworkingServiceTests.swift
//  RepositoryStatisticsTests
//
//  Created by Veronica Gliga on 28.10.2024.
//

import XCTest
@testable import RepositoryStatistics

final class NetworkingServiceTests: XCTestCase {
    
    var baseURL: URL!
    var mockSession: MockURLSession!
    var networkingService: NetworkingService<MockEndpoint>!
    
    override func setUp() {
        super.setUp()
        baseURL = URL(string: "https://api.example.com")!
        mockSession = MockURLSession()
        networkingService = NetworkingService(baseURL: baseURL, session: mockSession)
    }
    
    override func tearDown() {
        baseURL = nil
        mockSession = nil
        networkingService = nil
        super.tearDown()
    }
    
    // Test for successful response and decoding
    func testRequest_SuccessfulResponse() async throws {
        // Given
        let expectedData = try JSONEncoder().encode(["key": "value"])
        mockSession.dataToReturn = expectedData
        mockSession.responseToReturn = HTTPURLResponse(url: baseURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        // When
        let response: [String: String] = try await networkingService.request(MockEndpoint(path: "test", httpMethod: .get), 
                                                                             for: [String: String].self)
        
        // Then
        XCTAssertEqual(response["key"], "value")
    }
    
    // Test for invalid response status code
    func testRequest_InvalidResponseStatusCode() async {
        // Given
        mockSession.responseToReturn = HTTPURLResponse(url: baseURL, statusCode: 500, httpVersion: nil, headerFields: nil)
        
        // Then
        do {
            _ = try await networkingService.request(MockEndpoint(path: "test", httpMethod: .get), for: [String: String].self)
            XCTFail("Expected NetworkError.invalidResponse, but no error was thrown")
        } catch let error as NetworkError {
            // Then
            if case let .invalidResponse(statusCode) = error {
                XCTAssertEqual(statusCode, 500)
            } else {
                XCTFail("Expected NetworkError.invalidResponse with status code 500, got \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    // Test for no data response
    func testRequest_NoData() async {
        // Given
        mockSession.dataToReturn = Data()  // empty data
        
        // Then
        do {
            _ = try await networkingService.request(MockEndpoint(path: "test", httpMethod: .get), for: [String: String].self)
            XCTFail("Expected NetworkError.noData, but no error was thrown")
        } catch let error as NetworkError {
            // Then
            if case .noData = error {
                XCTAssertTrue(true)  // Success
            } else {
                XCTFail("Expected NetworkError.noData, got \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    // Test for decoding failure
    func testRequest_DecodingError() async {
        // Given
        let invalidData = "invalid data".data(using: .utf8)!
        mockSession.dataToReturn = invalidData
        mockSession.responseToReturn = HTTPURLResponse(url: baseURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        // Then
        do {
            _ = try await networkingService.request(MockEndpoint(path: "test", httpMethod: .get), for: [String: String].self)
            XCTFail("Expected NetworkError.decodingError, but no error was thrown")
        } catch let error as NetworkError {
            // Then
            if case .decodingError = error {
                XCTAssertTrue(true)  // Success
            } else {
                XCTFail("Expected NetworkError.decodingError, got \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
