//
//  UsersListViewController.swift
//  GitHubUsersListAppMVC
//
//  Created by Владимир Паутов on 06.04.2021.
//

import UIKit

class UsersListViewController: UITableViewController {
    
    // MARK: - Private properties
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var users = [User]()
    private var isFetching = false
    private var primaryRequest = true
    private var nextPageURL: URL?
    
    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupSearchController()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserTableViewCell
        cell.configure(with: users[indexPath.row])
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let position = scrollView.contentOffset.y
//        if position > (tableView.contentSize.height - 100 - scrollView.frame.size.height) {
//            guard !users.isEmpty, !isFetching else { return }
//            getUsers(with: nextPageURL)
//        }
//    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height - scrollView.frame.size.height) {
            guard !users.isEmpty, !isFetching else { return }
            tableView.tableFooterView = setupFooterView()
            getUsers(with: nextPageURL)
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    // MARK: - Private methods
    private func setupTableView() {
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .onDrag
        //tableView.prefetchDataSource = self

    }
    
    private func setupFooterView() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = footerView.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        footerView.addSubview(activityIndicator)
        return footerView
    }
    
    private func setupSearchController() {
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func getUsers(with url: URL?) {
        isFetching = true
        
        NetworkManager.shared.fetchUsers(url: url) { [weak self] result, url in
            
            guard let self = self else { return }
            
            switch result {
            
            case .success((let results)):
                guard let users = results.items else { return }
                self.nextPageURL = url
                self.updateUsersList(with: users)
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(title: "Error!", message: error.description)
                    self.tableView.tableFooterView = nil
                }
            }
            self.isFetching = false
            print(self.isFetching)
        }
    }
    
    private func updateUsersList(with users: [User]) {
        
        //        self.users.append(contentsOf: users)
        
        
        DispatchQueue.main.async {
            self.users.append(contentsOf: users)
            self.tableView.tableFooterView = nil
            if self.primaryRequest {
                self.tableView.reloadData()
                self.primaryRequest = false
            } else {
                let indexPathsToReload = self.calculateIndexPathsToReload(with: users)
                self.tableView.insertRows(at: indexPathsToReload, with: .fade)
            }
        }
    }
    
    private func calculateIndexPathsToReload(with users: [User]) -> [IndexPath] {
        let startIndex = self.users.count - users.count
        let endIndex = startIndex + users.count
        let indexPathsToReload = (startIndex..<endIndex).map { IndexPath(row: $0, section: 0)}
        return indexPathsToReload
    }
    
    private func clearCurrentUsersList() {
        nextPageURL = nil
        primaryRequest = true
        users.removeAll()
        tableView.tableFooterView = UIView()
        tableView.reloadData()
    }
}

// MARK: - Extensions

// MARK: - Search results updating
extension UsersListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
    }
}

// MARK: - Search bar delegate
extension UsersListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        clearCurrentUsersList()
        tableView.tableFooterView = setupFooterView()
        
        guard let searchText = searchBar.text else { return }
        guard !searchText.isEmpty else { return }
        
        //tableView.tableFooterView = addFooterView()
        
        let endpoint = Endpoint.search(searchText: searchText)
        
        getUsers(with: endpoint.url)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        clearCurrentUsersList()
    }
}

// MARK: - Text field delegate
extension UsersListViewController: UITextFieldDelegate {
    
    private func hideKeyboardByTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        //tapGesture.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func hideKeyboard() {
        searchController.searchBar.endEditing(true)
    }
}

extension UsersListViewController: AlertDisplayer {
    
}
