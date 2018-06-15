//
//  UsersProvider.swift
//  Users
//
//  Created by Ivan Petrukha on 15.06.2018.
//  Copyright © 2018 cellforrow. All rights reserved.
//

import Foundation

protocol UsersProvider {
    func fetchUsers(page: Int, perPage: Int, completion: @escaping(([User]) -> Void))
}

extension UsersProvider {
    
    func fetchUsers(baseURL: URL, path: String, page: Int, perPage: Int, completion: @escaping(([User]) -> Void)) {
        
        if let url = URL.with(baseURL: baseURL, path: path, queryItems: self.queryItems(forPage: page, perPage: perPage)) {
            
            let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    if let users = try? JSONDecoder.fromSnakeCase.decode([User].self, from: data) {
                        completion(users)
                    }
                }
            }
            
            dataTask.resume()
        }
    }
    
    func queryItems(forPage page: Int, perPage: Int) -> [URLQueryItem] {
        return [
            URLQueryItem(name: "per_page", value: "\(perPage)"),
            URLQueryItem(name: "page", value: "\(page)")
        ]
    }
}

class GithubUsersProvider: UsersProvider {
    
    let baseURL: URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    func fetchUsers(page: Int = 0, perPage: Int, completion: @escaping(([User]) -> Void)) {
        self.fetchUsers(
            baseURL: self.baseURL,
            path: "/users",
            page: page,
            perPage: perPage,
            completion: completion
        )
    }
}

class UserFollowersProvider: UsersProvider {
    
    let baseURL: URL
    let user: User
    
    init(baseURL: URL, user: User) {
        self.baseURL = baseURL
        self.user = user
    }
    
    func fetchUsers(page: Int = 0, perPage: Int, completion: @escaping (([User]) -> Void)) {
        self.fetchUsers(
            baseURL: self.baseURL,
            path: "/user/\(self.user.id)/followers",
            page: page,
            perPage: perPage,
            completion: completion
        )
    }
}
