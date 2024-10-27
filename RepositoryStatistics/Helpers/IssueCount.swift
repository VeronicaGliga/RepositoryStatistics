//
//  IssuesCount.swift
//  RepositoryStatistics
//
//  Created by Veronica Gliga on 23.10.2024.
//

import Foundation

struct IssueCount: Identifiable {
    var id = UUID()
    let weekStart: Date
    let count: Int
    
    var formattedWeekStart: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: weekStart)
    }
}
