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
                                        multiplier: period == .OneDay ? 15 : 1,
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
    
    func getMovingAverage(ticker: String, period: TimePeriod) async -> [MovingAverage] {
        var movingAverageArray: [MovingAverage] = []
        do {
            /*repeat {
                let response = try await client.getSimpleMovingAverage(ticker: ticker,
                                                                       timespan: period.toTimespan(), 
                                                                       cursor: cursor)
                movingAverageArray.append(contentsOf: response.results.values.map{ $0.toMovingAverage() })
                let split = response.nextURL?.split(separator: "cursor=")
                cursor = (split?.count ?? 0) > 1 ? split?[1].trimmingCharacters(in: .whitespacesAndNewlines) : nil
            } while(cursor != nil)*/
            let response = try await client.getSimpleMovingAverage(ticker: ticker,
                                                                   timespan: period.toTimespan())
            movingAverageArray = response.results.values.map{ $0.toMovingAverage() }
        } catch {
            debugPrint(error)
        }
        return movingAverageArray
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
            return AggregateTimespan.minute
        case .OneWeek:
            return AggregateTimespan.hour
        case .OneMonth:
            return AggregateTimespan.day
        case .ThreeMonths:
            return AggregateTimespan.day
        case .OneYear:
            return AggregateTimespan.day
        case .FiveYear:
            return AggregateTimespan.day
        }
    }
}
