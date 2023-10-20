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
        let headers = ["Authorization":"Bearer \(Configuration.apiKey)"]
        let transport = UrlSessionTransport(headers: headers)
        Resolver.shared.register(PolygonClient(transport: transport))
    }
}
