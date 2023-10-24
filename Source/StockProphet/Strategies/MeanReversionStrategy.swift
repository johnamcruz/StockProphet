//
//  MeanReversionStrategy.swift
//  StockProphet
//
//  Created by John M Cruz on 10/23/23.
//

import Foundation

class MeanReversionStrategy: TradingStrategy {

    // The symbol of the stock to track.
    private let symbol: String

    // The number of days to use for the mean calculation.
    private let period: Int

    // The minimum price change to trigger a buy or sell signal.
    private let threshold: Double

    // The current position in the stock.
    private var position: Int

    // The market data provider.
    private let marketDataProvider: MarketDataProvider

    // The order executor.
    private let orderExecutor: OrderExecutor

    init(symbol: String, period: Int, threshold: Double, marketDataProvider: MarketDataProvider, orderExecutor: OrderExecutor) {
        self.symbol = symbol
        self.period = period
        self.threshold = threshold
        self.position = 0
        self.marketDataProvider = marketDataProvider
        self.orderExecutor = orderExecutor
    }

    // Calculates the mean price of the stock over the specified period.
    private func calculateMeanPrice(data: [Double]) -> Double {
        var meanPrice = 0.0

        for price in data {
            meanPrice += price
        }

        meanPrice /= Double(data.count)

        return meanPrice
    }

    // Generates a buy or sell signal based on the current price of the stock and the mean price.
    private func generateSignal(currentPrice: Double, meanPrice: Double) -> TradeSignal {
        if currentPrice < meanPrice - threshold {
            return .buy
        } else if currentPrice > meanPrice + threshold {
            return .sell
        } else {
            return .hold
        }
    }

    // Places a buy or sell order based on the generated signal.
    internal func executeSignal(signal: TradeSignal) async {
        switch signal {
        case .buy:
            await orderExecutor.buy(symbol: symbol)
        case .sell:
            await orderExecutor.sell(symbol: symbol)
        case .hold:
            break
        }
    }

    // Updates the position in the stock based on the executed order.
    internal func updatePosition(signal: TradeSignal) async {
        switch signal {
        case .buy:
            position += 1
        case .sell:
            position -= 1
        case .hold:
            break
        }
    }

    // Runs the algorithm and generates a buy or sell signal.
    public func run() async -> TradeSignal {
        let data = marketDataProvider.getHistoricalPrices(symbol: symbol, period: period)
        let meanPrice = calculateMeanPrice(data: data)
        let currentPrice = marketDataProvider.getCurrentPrice(symbol: symbol)
        let signal = generateSignal(currentPrice: currentPrice, meanPrice: meanPrice)

        await executeSignal(signal: signal)
        await updatePosition(signal: signal)

        return signal
    }
}
