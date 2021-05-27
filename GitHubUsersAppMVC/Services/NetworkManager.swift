//
//  NetworkManager.swift
//  GitHubUsersListAppMVC
//
//  Created by Владимир Паутов on 06.04.2021.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private func getRequest(url: URL?, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let url = url else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
        }.resume()
    }
    
    private func fetchData<T: Decodable>(url: URL?, completion: @escaping (Result<T, DataError>, URL?) -> Void) {
        getRequest(url: url) { data, response, _ in
            guard let response = response as? HTTPURLResponse,
                  response.isStatusCodeSuccess,
                  let data = data else {
                completion(.failure(.network), nil)
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                let url = response.getNextPageURL()
                completion(.success(decodedData), url)
            } catch {
                completion(.failure(.decoding), nil)
                return
            }
        }
    }
    
    func fetchUsers(url: URL?, completion: @escaping (Result<SearchResults, DataError>, URL?) -> Void) {
        
        fetchData(url: url, completion: completion)
    }
}
