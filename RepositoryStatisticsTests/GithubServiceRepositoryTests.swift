//
//  GithubServiceRepositoryTests.swift
//  RepositoryStatisticsTests
//
//  Created by Veronica Gliga on 28.10.2024.
//

import XCTest
@testable import RepositoryStatistics

final class GithubServiceRepositoryTests: XCTestCase {
    // MARK: - Properties
    
    var mockURLSession: MockURLSession!
    var mockNetworkingService: MockNetworkingService<ApiTarget>!
    var githubServiceRepository: GithubServiceRepository!
    
    let repositoryJSON = """
            [
                {
                    "id": 1,
                    "name": "TestRepo",
                    "owner": {
                        "id": 101,
                        "login": "octocat"
                    },
                    "description": "A test repository",
                    "stargazers_count": 42,
                    "forks_count": 10,
                    "html_url": "https://github.com/octocat/TestRepo"
                }
            ]
            """.data(using: .utf8)!
    
    // MARK: - Setup
    
    override func setUp() {
        super.setUp()
        
        mockURLSession = MockURLSession()
        mockNetworkingService = MockNetworkingService(baseURL: URL(string: "https://example.com")!, session: mockURLSession)
        githubServiceRepository = GithubServiceRepository(networkProvider: mockNetworkingService)
    }
    
    override func tearDown() {
        mockURLSession = nil
        mockNetworkingService = nil
        githubServiceRepository = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testFetchPublicRepositories_success() async throws {
        // Given: a mocked response with valid repository JSON data
        let decoder = JSONDecoder()
        let expectedRepositories = try decoder.decode([Repository].self, from: repositoryJSON)
        
        mockURLSession.dataToReturn = repositoryJSON
        mockURLSession.responseToReturn = HTTPURLResponse(
            url: URL(string: "https://example.com/repositories")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        // When: fetching public repositories
        let repositories = try await githubServiceRepository.fetchPublicRepositories()
        
        // Then: verify that the fetched repositories match the expected data
        XCTAssertEqual(repositories.count, expectedRepositories.count)
        XCTAssertTrue(repositoriesArraysAreEqual(repositories, expectedRepositories), "The fetched repositories should match the expected mock repositories")
    }
    
    func testFetchPublicRepositories_failure() async {
        // Given: a mocked server error response
        mockURLSession.dataToReturn = Data() // No data
        mockURLSession.responseToReturn = HTTPURLResponse(
            url: URL(string: "https://example.com/repositories")!,
            statusCode: 500,  // Simulate a bad server response
            httpVersion: nil,
            headerFields: nil
        )
        
        // When: attempting to fetch repositories should fail
        do {
            _ = try await githubServiceRepository.fetchPublicRepositories()
            XCTFail("Expected failure due to bad server response, but got success")
        } catch let error as NetworkError {
            // Then: Assert that the error is `invalidResponse` with status code 500
            if case .invalidResponse(let statusCode) = error {
                XCTAssertEqual(statusCode, 500, "Expected status code 500 in error, but got \(statusCode)")
            } else {
                XCTFail("Expected NetworkError.invalidResponse, but got a different error")
            }
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
    
    // MARK: - Helpers
    
    // Helper method to compare two repositories
    private func repositoriesAreEqual(_ lhs: Repository, _ rhs: Repository) -> Bool {
        return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.owner.id == rhs.owner.id &&
        lhs.owner.name == rhs.owner.name &&
        lhs.description == rhs.description &&
        lhs.url == rhs.url
    }
    
    // Helper method to compare two arrays of repositories
    private func repositoriesArraysAreEqual(_ lhs: [Repository], _ rhs: [Repository]) -> Bool {
        guard lhs.count == rhs.count else { return false }
        for (index, repo) in lhs.enumerated() {
            if !repositoriesAreEqual(repo, rhs[index]) {
                return false
            }
        }
        return true
    }
}
