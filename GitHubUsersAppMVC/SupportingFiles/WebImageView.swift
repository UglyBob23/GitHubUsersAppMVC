//
//  WebImageView.swift
//  GitHubUsersListAppMVC
//
//  Created by Владимир Паутов on 08.04.2021.
//

import UIKit

class WebImageView: UIImageView {
    
    func setImage(from imageURL: String?) {
        
        guard let imageURL = imageURL, let url = URL(string: imageURL) else { return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            
            DispatchQueue.main.async {
                if let data = data {
                    self?.image = UIImage(data: data)
                }
            }
        }
        dataTask.resume()
    }
}
