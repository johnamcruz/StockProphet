//
//  StockServiceable.swift
//  StockProphet
//
//  Created by John M Cruz on 10/15/23.
//

import Foundation

protocol StockServiceable {
    func load(ticker: String, period: TimePeriod, from: Date, to: Date) async -> [Stock]
}
