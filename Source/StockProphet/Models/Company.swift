//
//  StockItem.swift
//  StockProphet
//
//  Created by John M Cruz on 10/15/23.
//

import Foundation
import SwiftData

@Model
final class Company: Identifiable {
    var name: String
    var ticker: String
    var price: Decimal
    
    init(name: String, ticker: String, price: Decimal) {
        self.name = name
        self.ticker = ticker
        self.price = price
    }
    
    var id: String {
        ticker
    }
}

extension Company {
    static var mock: Company {
        Company(name: "Apple", ticker: "APPL", price: 178.0)
    }
    
    static var all: [Company] {
        [
            Company(name: "Apple Inc", ticker: "AAPL", price: 178.0),
            Company(name: "Amazon Inc", ticker: "AMZN", price: 178.0),
            Company(name: "Google Inc", ticker: "GOOGL", price: 178.0),
            Company(name: "Micrsoft Inc", ticker: "MSFT", price: 178.0),
        ]
    }
}
