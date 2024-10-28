//
//  IssuesCount.swift
//  RepositoryStatistics
//
//  Created by Veronica Gliga on 23.10.2024.
//

import Foundation

struct GroupedIssue: Identifiable {
    var id = UUID()
    let weekStart: Date
    let count: Int
}
