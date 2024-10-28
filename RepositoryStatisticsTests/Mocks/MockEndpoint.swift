//
//  MockEndpoint.swift
//  RepositoryStatisticsTests
//
//  Created by Veronica Gliga on 28.10.2024.
//

import Foundation
@testable import RepositoryStatistics

struct MockEndpoint: Endpoint {
    var path: String
    var httpMethod: HTTPMethod
}
