//
//  UsersListViewController+AlertController.swift
//  GitHubUsersAppMVC
//
//  Created by Владимир Паутов on 20.04.2021.
//

import UIKit

protocol AlertDisplayer {
    func showAlert(title: String, message: String)
}

extension AlertDisplayer where Self: UIViewController {
    
    func showAlert(title: String, message: String) {
        guard !(navigationController?.visibleViewController?.isKind(of: UIAlertController.self))! else { return }
        print("ALERT!!!")
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(OKAction)
        present(alertController, animated: true)
    }
}

//extension UsersListViewController {
//
//    func showAlert(title: String, message: String) {
//        guard presentedViewController == nil else {
//            print("already presenting")
//            return }
//        print("ALERT!!!")
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let OKAction = UIAlertAction(title: "OK", style: .default)
//        alertController.addAction(OKAction)
//        present(alertController, animated: true)
//    }
//}
