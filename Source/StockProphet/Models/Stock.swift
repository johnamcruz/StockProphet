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
    var volume: Float
    var date: Date
    var open: Decimal
    var close: Decimal
    var high: Decimal
    var low: Decimal
}
