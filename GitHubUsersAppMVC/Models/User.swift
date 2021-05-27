//
//  User.swift
//  GitHubUsersListAppMVC
//
//  Created by Владимир Паутов on 08.04.2021.
//

import Foundation

struct User: Decodable {
    
    let login: String?
    let avatar_url: String?
    let type: String?
}

struct SearchResults: Decodable {
    
    let total_count: Int?
    let incomplete_results: Bool?
    let items: [User]?
}
