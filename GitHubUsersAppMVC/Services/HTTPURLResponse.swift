//
//  HTTPURLResponse.swift
//  GitHubUsersListAppMVC
//
//  Created by Владимир Паутов on 07.04.2021.
//

import Foundation

extension HTTPURLResponse {
    
    var isStatusCodeSuccess: Bool {
        return 200...299 ~= statusCode
    }
}

extension HTTPURLResponse {
    
    func getNextPageURL() -> URL? {
        
        guard let linkHeader = self.value(forHTTPHeaderField: "Link") else {
            return nil
        }
        let links = linkHeader.components(separatedBy: ", ")
        
        var dictionary: [String: String] = [:]
        links.forEach({
            let components = $0.components(separatedBy:"; ")
            let cleanPath = components[0].trimmingCharacters(in: CharacterSet(charactersIn: "<>"))
            dictionary[components[1]] = cleanPath
        })
        
        if let nextPagePath = dictionary["rel=\"next\""] {
            return URL(string: nextPagePath)
        }
        return nil
    }
}
