//
//  StockServiceable.swift
//  StockProphet
//
//  Created by John M Cruz on 10/15/23.
//

import Foundation

protocol StockServiceable {
    func load() async
    func getStock(ticker: String) -> [Stock]
    func getAllStocks() -> [Stock]
}
