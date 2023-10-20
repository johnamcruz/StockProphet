//
//  StockService.swift
//  StockProphet
//
//  Created by John M Cruz on 10/19/23.
//

import Foundation
import PolygonClient

class StockService: StockServiceable {
    var client: PolygonClient {
        Resolver.shared.resolve(name: String(describing: PolygonClient.self))
    }
    
    func load(ticker: String, period: TimePeriod, from: Date, to: Date) async -> [Stock] {
        var results: [Stock] = []
        let request = AggregatesRequest(ticker: ticker,
                                        multiplier: period.toMultiplier(),
                                        timespan: period.toTimespan(),
                                        from: from,
                                        to: to)
        do {
            let response = try await client.getAggregates(request: request)
            results = response.results.map { $0.toStock(ticker: ticker) }
        } catch {
            debugPrint(error)
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

extension TimePeriod {
    func toTimespan() -> AggregateTimespan {
        switch self {
        case .OneDay:
            return AggregateTimespan.hour
        case .OneWeek:
            return AggregateTimespan.week
        case .OneMonth:
            return AggregateTimespan.month
        case .ThreeMonths:
            return AggregateTimespan.month
        case .OneYear:
            return AggregateTimespan.year
        case .FiveYear:
            return AggregateTimespan.year
        }
    }
    
    func toMultiplier() -> Int {
        switch self {
        case .OneDay:
            return 24
        case .OneWeek:
            return 7
        case .OneMonth:
            return 1
        case .ThreeMonths:
            return 3
        case .OneYear:
            return 1
        case .FiveYear:
            return 5
        }
    }
}
