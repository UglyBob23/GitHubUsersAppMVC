//
//  UserTableViewCell.swift
//  GitHubUsersListAppMVC
//
//  Created by Владимир Паутов on 06.04.2021.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: WebImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userTypeLabel: UILabel!
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//
//        configure(with: .none)
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        activityIndicator.hidesWhenStopped = true
    }
    
    
    func configure(with user: User?) {
        
        setupCell()
        if let user = user {
            userNameLabel.text = user.login
            userTypeLabel.text = user.type
            self.userImageView.setImage(from: user.avatar_url)
            userImageView.alpha = 1
            userNameLabel.alpha = 1
            userTypeLabel.alpha = 1
            activityIndicator.stopAnimating()
        } else {
            userImageView.alpha = 0
            userNameLabel.alpha = 0
            userTypeLabel.alpha = 0
            activityIndicator.startAnimating()
            return
        }
    }
    
    private func setupCell() {
        userImageView.layer.cornerRadius = userImageView.bounds.height / 2
        userTypeLabel.textColor = .gray
    }
    
}
