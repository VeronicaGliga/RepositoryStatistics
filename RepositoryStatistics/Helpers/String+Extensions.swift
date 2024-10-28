//
//  String+Extensions.swift
//  RepositoryStatistics
//
//  Created by Veronica Gliga on 28.10.2024.
//

import Foundation

extension String {
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.date(from: self)
    }
}
