//
//  NetworkError.swift
//  Foodimity
//
//  Created by Syed Muhammad Aaqib Hussain on 19.03.23.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidServerResponse
    case invalidURL
    case invalidPath
    case error(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidServerResponse:
            return "The server returned an invalid response."
        case .invalidURL:
            return "URL string is malformed."
        case .invalidPath:
            return "File doesn't exist at path."
        case let .error(error):
            return error.localizedDescription
        }
    }
}
