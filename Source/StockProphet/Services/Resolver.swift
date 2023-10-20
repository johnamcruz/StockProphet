//
//  Resolver.swift
//  StockProphet
//
//  Created by John M Cruz on 10/15/23.
//

import Foundation

protocol Locator {
    func resolve<Component: Any>() -> Component
    func resolve<Component: Any>(name: String) -> Component
    func register<Component: Any>(_ component: Component)
    func register<Component: Any>(name: String, _ component: Component)
}

// Resolver resolves any injected property that inherits from anyobject
final class Resolver: Locator {
    static let shared = Resolver()
    private var services: [String: Any] = [:]
    
    // resolves the component if it is found in the dictionary
    func resolve<Component>() -> Component {
        resolve(name: String(describing: Component.self))
    }
    
    // resolves the component if its found in the dictionary
    func resolve<Component>(name: String) -> Component {
        guard let component = self.services[name] as? Component else {
            fatalError("\(name) has not been added as an injectable object.")
        }
        return component
    }
    
    // adds the component to the dictionary for easy lookup
    func register<Component>(_ component: Component) {
        register(name: String(describing: Component.self), component)
    }
    
    // adds the component to a dictionary for easy lookup
    func register<Component>(name: String, _ component: Component) {
        self.services[name] = component
    }
    
    func clearAllServices() {
        services = [:]
    }
}
