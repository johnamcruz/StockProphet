//
//  StockProphetApp.swift
//  StockProphet
//
//  Created by John M Cruz on 10/15/23.
//

import SwiftUI
import SwiftData
import PolygonClient

@main
struct StockProphetApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Company.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(sharedModelContainer)
    }
    
    init() {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let transport = UrlSessionTransport(session: session, apiKey: Configuration.apiKey)
        Resolver.shared.register(PolygonClient(transport: transport))
    }
}
