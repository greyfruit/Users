//
//  Configurable.swift
//  Users
//
//  Created by Ivan Petrukha on 15.06.2018.
//  Copyright © 2018 cellforrow. All rights reserved.
//

import Foundation

protocol Configurable: class {
    
    associatedtype Configurator
    
    func configure(with configurator: Configurator)
}

extension Configurable {
    
    func configured(with configurator: Configurator) -> Self {
        
        self.configure(with: configurator)
        
        return self
    }
}

protocol Delegating: class {
    
    associatedtype Delegate
    
    var delegate: Delegate? { get set }
}

extension Delegating {
    
    func withDelegate(_ delegate: Delegate) -> Self {
        
        self.delegate = delegate
        
        return self
    }
}

extension Configurable where Self: Delegating {
    
    func configured(with configurator: Configurator, delegate: Delegate) -> Self {
        
        return self.configured(with: configurator).withDelegate(delegate)
    }
}
