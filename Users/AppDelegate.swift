//
//  AppDelegate.swift
//  Users
//
//  Created by Ivan Petrukha on 15.06.2018.
//  Copyright © 2018 cellforrow. All rights reserved.
//

import UIKit

let baseURL: URL = URL(string: "https://api.github.com/")!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        guard
            let navigationController = self.window?.rootViewController as? UINavigationController,
            let usersTableViewController = navigationController.topViewController as? UsersTableViewController
            else { fatalError() }
        
        usersTableViewController.usersProvider = GithubUsersProvider(
            baseURL: baseURL
        )
        
        return true
    }
}

