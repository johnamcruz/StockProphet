//
//  MarketDataProvider.swift
//  StockProphet
//
//  Created by John M Cruz on 10/23/23.
//

import Foundation

protocol MarketDataProvider {
    func getCurrentPrice(symbol: String) -> Double
    func getHistoricalPrices(symbol: String, period: Int) -> [Double]
}
