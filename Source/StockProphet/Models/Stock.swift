//
//  Stock.swift
//  StockProphet
//
//  Created by John M Cruz on 10/15/23.
//

import Foundation

struct Stock: Codable, Identifiable {
    var id: String = UUID().uuidString
    var name: String
    var volume: Int64
    var date: Date
    var open: Double
    var close: Double
    var high: Double
    var low: Double
    var prediction: Double?
}

extension Stock {
    func toInput() -> StockForecastingModelInput {
        StockForecastingModelInput(date: self.date.formatted(),
                                   open: self.open,
                                   high: self.high,
                                   low: self.low,
                                   volume: self.volume)
    }
}
