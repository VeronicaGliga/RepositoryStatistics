//
//  GithubServiceIssuesTests.swift
//  RepositoryStatisticsTests
//
//  Created by Veronica Gliga on 28.10.2024.
//

import XCTest
@testable import RepositoryStatistics

class GithubServiceIssuesTests: XCTestCase {
    // MARK: - Properties
    
    var mockURLSession: MockURLSession!
    var githubServiceIssues: GithubServiceIssues!
    var mockNetworkingService: MockNetworkingService<ApiTarget>!
    
    let issuesJSON = """
        [
            {
                "id": 1,
                "created_at": "2024-10-28T12:34:56Z",
                "state": "open"
            }
        ]
        """.data(using: .utf8)!
    
    let stargazersJSON = """
        [
            {
                "id": 1
            }
        ]
        """.data(using: .utf8)!
    
    let forksJSON = """
        [
            {
                "id": 1
            }
        ]
        """.data(using: .utf8)!
    
    // MARK: - Setup
    
    override func setUp() {
        super.setUp()
        mockURLSession = MockURLSession()
        mockNetworkingService = MockNetworkingService(baseURL: URL(string: "https://api.github.com")!, session: mockURLSession)
        githubServiceIssues = GithubServiceIssues(networkProvider: mockNetworkingService)
    }
    
    override func tearDown() {
        mockURLSession = nil
        mockNetworkingService = nil
        githubServiceIssues = nil
        super.tearDown()
    }
    
    // MARK: - Tests for fetchIssues
    
    func testFetchIssues_success() async throws {
        // Given: a successful response with valid issues JSON data
        let decoder = JSONDecoder()
        let expectedIssues = try decoder.decode([Issue].self, from: issuesJSON)
        
        mockURLSession.dataToReturn = issuesJSON
        mockURLSession.responseToReturn = HTTPURLResponse(
            url: URL(string: "https://example.com/repos/octocat/repo/issues")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        // When: fetching issues
        let issues = try await githubServiceIssues.fetchIssues(for: "repo", owner: "octocat")
        
        // Then: fetched issues should match the expected data
        XCTAssertTrue(issuesArraysAreEqual(issues, expectedIssues))
    }
    
    func testFetchIssues_failure() async {
        // Given: a server error response (500)
        mockURLSession.responseToReturn = HTTPURLResponse(
            url: URL(string: "https://example.com/repos/octocat/repo/issues")!,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil
        )
        
        // When: fetching issues
        do {
            _ = try await githubServiceIssues.fetchIssues(for: "repo", owner: "octocat")
            XCTFail("Expected failure due to server error, but got success")
        } catch let error as NetworkError {
            if case .invalidResponse(let statusCode) = error {
                XCTAssertEqual(statusCode, 500)
            } else {
                XCTFail("Expected NetworkError.invalidResponse, but got a different error")
            }
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
    
    // MARK: - Tests for fetchStargazers
    
    func testFetchStargazers_success() async throws {
        // Given: a successful response with valid stargazers JSON data
        let decoder = JSONDecoder()
        let expectedStargazers = try decoder.decode([Stargazer].self, from: stargazersJSON)
        
        mockURLSession.dataToReturn = stargazersJSON
        mockURLSession.responseToReturn = HTTPURLResponse(
            url: URL(string: "https://example.com/repos/octocat/repo/stargazers")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        // When: fetching stargazers
        let stargazers = try await githubServiceIssues.fetchStargazers(for: "repo", owner: "octocat")
        
        // Then: fetched stargazers should match the expected data
        XCTAssertTrue(stargazersArraysAreEqual(stargazers, expectedStargazers))
    }
    
    func testFetchStargazers_failure() async {
        // Given: a server error response (500)
        mockURLSession.responseToReturn = HTTPURLResponse(
            url: URL(string: "https://example.com/repos/octocat/repo/stargazers")!,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil
        )
        
        // When: fetching stargazers
        do {
            _ = try await githubServiceIssues.fetchStargazers(for: "repo", owner: "octocat")
            XCTFail("Expected failure due to server error, but got success")
        } catch let error as NetworkError {
            if case .invalidResponse(let statusCode) = error {
                XCTAssertEqual(statusCode, 500)
            } else {
                XCTFail("Expected NetworkError.invalidResponse, but got a different error")
            }
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
    
    // MARK: - Tests for fetchForks
    
    func testFetchForks_success() async throws {
        // Given: a successful response with valid forks JSON data
        let decoder = JSONDecoder()
        let expectedForks = try decoder.decode([Fork].self, from: forksJSON)
        
        mockURLSession.dataToReturn = forksJSON
        mockURLSession.responseToReturn = HTTPURLResponse(
            url: URL(string: "https://example.com/repos/octocat/repo/forks")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        // When: fetching forks
        let forks = try await githubServiceIssues.fetchForks(for: "repo", owner: "octocat")
        
        // Then: fetched forks should match the expected data
        XCTAssertTrue(forksArraysAreEqual(forks, expectedForks))
    }
    
    func testFetchForks_failure() async {
        // Given: a server error response (500)
        mockURLSession.responseToReturn = HTTPURLResponse(
            url: URL(string: "https://example.com/repos/octocat/repo/forks")!,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil
        )
        
        // When: fetching forks
        do {
            _ = try await githubServiceIssues.fetchForks(for: "repo", owner: "octocat")
            XCTFail("Expected failure due to server error, but got success")
        } catch let error as NetworkError {
            if case .invalidResponse(let statusCode) = error {
                XCTAssertEqual(statusCode, 500)
            } else {
                XCTFail("Expected NetworkError.invalidResponse, but got a different error")
            }
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
    
    // MARK: - Hellpers
    
    private func issuesAreEqual(_ lhs: Issue, _ rhs: Issue) -> Bool {
        lhs.id == rhs.id &&
        lhs.createdAt == rhs.createdAt &&
        lhs.state == rhs.state
    }
    
    private func issuesArraysAreEqual(_ lhs: [Issue], _ rhs: [Issue]) -> Bool {
        guard lhs.count == rhs.count else { return false }
        for (index, repo) in lhs.enumerated() {
            if !issuesAreEqual(repo, rhs[index]) {
                return false
            }
        }
        return true
    }
    
    private func stargazersAreEqual(_ lhs: Stargazer, _ rhs: Stargazer) -> Bool {
        lhs.id == rhs.id
    }
    
    // Helper method to compare two arrays of repositories
    private func stargazersArraysAreEqual(_ lhs: [Stargazer], _ rhs: [Stargazer]) -> Bool {
        guard lhs.count == rhs.count else { return false }
        for (index, repo) in lhs.enumerated() {
            if !stargazersAreEqual(repo, rhs[index]) {
                return false
            }
        }
        return true
    }
    
    private func forksAreEqual(_ lhs: Fork, _ rhs: Fork) -> Bool {
        lhs.id == rhs.id
    }
    
    // Helper method to compare two arrays of repositories
    private func forksArraysAreEqual(_ lhs: [Fork], _ rhs: [Fork]) -> Bool {
        guard lhs.count == rhs.count else { return false }
        for (index, repo) in lhs.enumerated() {
            if !forksAreEqual(repo, rhs[index]) {
                return false
            }
        }
        return true
    }
}
