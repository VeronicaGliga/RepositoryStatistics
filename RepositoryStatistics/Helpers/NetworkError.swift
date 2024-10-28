//
//  NetworkError.swift
//  RepositoryStatistics
//
//  Created by Veronica Gliga on 23.10.2024.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidResponse(statusCode: Int)
    case noData
    case decodingError(Error)
    
    var errorDescription: String? {
            switch self {
            case .invalidResponse(let statusCode):
                return NSLocalizedString("Received an invalid response from the server (Status code: \(statusCode)). Please try again later.", comment: "Invalid Response")
            case .noData:
                return NSLocalizedString("No data was returned from the server. Please check your network connection or try again later.", comment: "No Data")
            case .decodingError(let error):
                return NSLocalizedString("An error occurred while decoding the data: \(error.localizedDescription)", comment: "Decoding Error")
            }
        }
}
