//
//  StockService.swift
//  StockProphet
//
//  Created by John M Cruz on 10/19/23.
//

import Foundation
import PolygonClient

class StockService: StockServiceable {
    let client: PolygonClient
    
    init() {
        let headers = ["Authorization":"Bearer \(Constants.apiKey)"]
        let transport = UrlSessionTransport(headers: headers)
        self.client = PolygonClient(transport: transport)
    }
    
    func load(ticker: String) async -> [Stock] {
        var results: [Stock] = []
        let request = AggregatesRequest(ticker: ticker, timespan: .day)
        do {
            let response = try await client.getAggregates(request: request)
            results = response.results.map { $0.toStock(ticker: ticker) }
        } catch {
            print(error.localizedDescription)
        }
        return results
    }
}

extension AggregatesResult {
    func toStock(ticker: String) -> Stock {
        Stock(name: ticker, 
              volume: Int64(self.volume),
              date: self.timestamp,
              open: self.open,
              close: self.close,
              high: self.high,
              low: self.low)
    }
}
