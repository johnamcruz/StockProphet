//
//  TradingStrategy.swift
//  StockProphet
//
//  Created by John M Cruz on 10/23/23.
//

import Foundation

protocol TradingStrategy {
    func executeSignal(signal: TradeSignal) async
    func updatePosition(signal: TradeSignal) async
    func run() async -> TradeSignal
}
