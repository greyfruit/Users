//
//  User.swift
//  Users
//
//  Created by Ivan Petrukha on 15.06.2018.
//  Copyright © 2018 cellforrow. All rights reserved.
//

import Foundation

struct User: Codable {
    
    let id: Int
    let login: String
    let htmlUrl: String
    let avatarUrl: String
}
