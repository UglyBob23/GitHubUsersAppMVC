//
//  ErrorManager.swift
//  GitHubUsersListAppMVC
//
//  Created by Владимир Паутов on 07.04.2021.
//

import Foundation

enum DataError: Error {
    case network
    case decoding
    
    var description: String {
        switch self {
        case .network:
            return "Failed to fetch data"
        case .decoding:
            return "Failed to decode data"
        }
    }
}
