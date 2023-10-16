//
//  StockItem.swift
//  StockProphet
//
//  Created by John M Cruz on 10/15/23.
//

import Foundation
import SwiftData

@Model
final class StockItem {
    var name: String
    var ticker: String
    var price: Decimal
    
    init(name: String, ticker: String, price: Decimal) {
        self.name = name
        self.ticker = ticker
        self.price = price
    }
}

extension StockItem {
    static var mock: StockItem {
        StockItem(name: "Apple", ticker: "APPL", price: 178.0)
    }
}
