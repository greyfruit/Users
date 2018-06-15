//
//  UsersTableViewController.swift
//  Users
//
//  Created by Ivan Petrukha on 15.06.2018.
//  Copyright © 2018 cellforrow. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    var usersProvider: UsersProvider!
    var users: [User] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var isLoading: Bool = false
    private var isLoaded: Bool = false
    private var currentPage: Int = 0
    private let perPage: Int = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadMoreUsers()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let usersTableViewController = segue.destination as? UsersTableViewController, let user = sender as? User {
            usersTableViewController.title = "\(user.login)'s followers"
            usersTableViewController.usersProvider = UserFollowersProvider(
                baseURL: baseURL,
                user: user
            )
        }
    }
}

private extension UsersTableViewController {
    
    func loadMoreUsers() {
        
        guard !self.isLoading && !self.isLoaded else {
            return
        }
        
        self.isLoading = true
        self.usersProvider.fetchUsers(page: self.currentPage, perPage: self.perPage) { users in
            self.users.append(contentsOf: users)
            self.currentPage += 1
            self.isLoaded = users.count < self.perPage
            self.isLoading = false
        }
    }
}

extension UsersTableViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset
        
        if deltaOffset <= 0 {
            self.loadMoreUsers()
        }
    }
}

extension UsersTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView
            .dequeueReusableCell(withType: UserTableViewCell.self, for: indexPath)
            .configured(with: self.users[indexPath.row], delegate: self)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(
            withIdentifier: "toUserFollowers",
            sender: self.users[indexPath.row]
        )
    }
}

extension UsersTableViewController: UserTableViewCellDelegate {
    
    func userTableViewCellDidSelectURL(_ sender: UserTableViewCell) {
        
        guard let indexPath = self.tableView.indexPath(for: sender) else {
            return
        }
        
        if let url = URL(string: self.users[indexPath.row].htmlUrl), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        }
    }
}
