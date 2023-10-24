//
//  OrderExecutor.swift
//  StockProphet
//
//  Created by John M Cruz on 10/23/23.
//

import Foundation

protocol OrderExecutor {
    func buy(symbol: String, orderQuantity: Int) async
    func sell(symbol: String, orderQuantity: Int) async
}
