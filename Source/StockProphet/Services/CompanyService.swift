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
            return try await withThrowingTaskGroup(of: Company.self) { group in
                let response = try await client.getTicker(ticker: "", query: query, order: .asc)
                results = response.results.map{ $0.toCompany() }
                
                for company in results {
                    group.addTask{
                        let company = company
                        async let details = self.client.getTickerDetails(ticker: company.ticker)
                        async let price = self.client.getDailyOpenClose(ticker: company.ticker, date: Date())
                        return try await Company(name: details.results.name, ticker: company.ticker, price: price.close)
                    }
                }
                
                var results: [Company] = []
                for try await company in group {
                    results.append(company)
                }
                return results
            }
            
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
