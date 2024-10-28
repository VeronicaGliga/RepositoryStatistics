//
//  Date+Extensions.swift
//  RepositoryStatistics
//
//  Created by Veronica Gliga on 28.10.2024.
//

import Foundation

extension Date {
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        return formatter.string(from: self)
    }
}
