//
//  Endpoint.swift
//  GitHubUsersAppMVC
//
//  Created by Владимир Паутов on 19.04.2021.
//

import Foundation

struct Endpoint {
    
    let path: String
    let queryItems: [URLQueryItem]
}

extension Endpoint {
    
    static func search(searchText: String) -> Endpoint {
        return Endpoint(path: "/search/users",
                        queryItems: [URLQueryItem(name: "q", value: searchText),
                                     URLQueryItem(name: "per_page", value: "15")])
    }
}

extension Endpoint {
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        components.path = path
        components.queryItems = queryItems
        
        return components.url
    }
}
