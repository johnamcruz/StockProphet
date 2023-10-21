//
//  CompanyService.swift
//  StockProphet
//
//  Created by John M Cruz on 10/20/23.
//

import Foundation
import PolygonClient

protocol CompanyServiceable {
    func load(date: Date) async -> [Company]
}

class CompanyService: CompanyServiceable {
    var client: PolygonClient {
        Resolver.shared.resolve(name: String(describing: PolygonClient.self))
    }
    
    func load(date: Date) async -> [Company] {
        var results: [Company] = []
        do {
            let response = try await client.getGroupDaily(date: date)
            results = response.results.map{ $0.toCompany() }
        } catch {
            debugPrint(error)
        }
        return results
    }
}

extension GroupedDailyResult {
    func toCompany() -> Company {
        Company(name: self.ticker, ticker: self.ticker, price: self.close)
    }
}
