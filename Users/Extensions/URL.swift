//
//  URL.swift
//  Users
//
//  Created by Ivan Petrukha on 15.06.2018.
//  Copyright © 2018 cellforrow. All rights reserved.
//

import Foundation

extension URL {
    
    static func with(baseURL: URL, path: String, queryItems: [URLQueryItem]) -> URL? {
        
        guard var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
            return nil
        }
        
        urlComponents.path = path
        urlComponents.queryItems = queryItems
        
        return urlComponents.url
    }
}
