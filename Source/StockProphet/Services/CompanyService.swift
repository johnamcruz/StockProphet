//
//  CompanyService.swift
//  StockProphet
//
//  Created by John M Cruz on 10/20/23.
//

import Foundation
import PolygonClient

protocol CompanyServiceable {
    func load(query: String) async -> [Company]
}

class CompanyService: CompanyServiceable {
    var client: PolygonClient {
        Resolver.shared.resolve(name: String(describing: PolygonClient.self))
    }
    
    func load(query: String) async -> [Company] {
        var results: [Company] = []
        do {
            let response = try await client.getTicker(ticker: "", query: query, order: .asc)
            results = response.results.map{ $0.toCompany() }
        } catch {
            debugPrint(error)
        }
        return results
        
       
    }
}

extension TickerResult {
    func toCompany() -> Company {
        Company(name: self.name, ticker: self.ticker, price: 0)
    }
}
