//
//  Stock.swift
//  StockProphet
//
//  Created by John M Cruz on 10/15/23.
//

import Foundation

struct Stock: Codable, Identifiable {
    var id: String
    var name: String
    var volume: Int64
    var date: Date
    var open: Double
    var close: Double
    var high: Double
    var low: Double
    var prediction: Double?
    
    init(name: String,
         volume: Int64,
         date: Date,
         open: Double,
         close: Double,
         high: Double,
         low: Double,
         prediction: Double? = nil) {
        self.id = UUID().uuidString
        self.name = name
        self.volume = volume
        self.date = date
        self.open = open
        self.close = close
        self.high = high
        self.low = low
        self.prediction = prediction
    }
}

extension Stock {
    func toInput() -> StockForecastingModelInput {
        StockForecastingModelInput(open: self.open,
                                   high: self.high,
                                   low: self.low,
                                   volume: self.volume)
    }
}
