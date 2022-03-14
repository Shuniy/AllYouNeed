//
//  RequestError.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 04/02/22.
//

import Foundation

//MARK: REQUEST ERROR
enum RequestError: Error {
    case apiError
    case invalidEndPoint
    case invalidResponse
    case noData
    case serializationError
    
    var localizedDescription: String {
        switch self {
        case .apiError:
            return "Failed to fetch Data!"
        case .invalidEndPoint:
            return "Invalid API URL or Endpoint!"
        case .invalidResponse:
            return "Invalid Response!"
        case .noData:
            return "No data received!"
        case .serializationError:
            return "Failed to Decode Data"
        }
    }
    
    var errorUserInfo: [String: Any] {
        [NSLocalizedDescriptionKey : localizedDescription]
    }
}
