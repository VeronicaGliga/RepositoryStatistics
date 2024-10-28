//
//  GithubServiceIssuesTests.swift
//  RepositoryStatisticsTests
//
//  Created by Veronica Gliga on 28.10.2024.
//

import XCTest
@testable import RepositoryStatistics

class GithubServiceIssuesTests: XCTestCase {
    var mockURLSession: MockURLSession!
    var githubServiceIssues: GithubServiceIssues!
    var mockNetworkingService: MockNetworkingService<ApiTarget>!
    
    override func setUp() {
        super.setUp()
        mockURLSession = MockURLSession()
        mockNetworkingService = MockNetworkingService(baseURL: URL(string: "https://api.github.com")!, session: mockURLSession)
        githubServiceIssues = GithubServiceIssues(networkProvider: mockNetworkingService)
    }
    
//    func testFetchIssues() async throws {
//        let expectedIssues = [Issue(id: 1, title: "Issue 1")]
//        mockNetworkingService.result = expectedIssues
//        
//        let issues = try await githubServiceIssues.fetchIssues(for: "hello-world", owner: "octocat")
//        XCTAssertEqual(issues, expectedIssues)
//    }
//    
//    func testFetchStargazers() async throws {
//        let expectedStargazers = [Stargazer(id: 1, username: "user1")]
//        mockNetworkingService.result = expectedStargazers
//        
//        let stargazers = try await githubServiceIssues.fetchStargazers(for: "hello-world", owner: "octocat")
//        XCTAssertEqual(stargazers, expectedStargazers)
//    }
//    
//    func testFetchForks() async throws {
//        let expectedForks = [Fork(id: 1, name: "ForkedRepo")]
//        mockNetworkingService.result = expectedForks
//        
//        let forks = try await githubServiceIssues.fetchForks(for: "hello-world", owner: "octocat")
//        XCTAssertEqual(forks, expectedForks)
//    }
}
