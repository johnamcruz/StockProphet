//
//  ChartDataViewModel.swift
//  StockProphet
//
//  Created by John M Cruz on 10/16/23.
//

import Foundation

struct ChartDataViewModel {
    let stocks: [Stock]
    let zoom: ClosedRange<CGFloat>
    let minPrice: Double
    let maxPrice: Double
    let movingAverage: Double
}

extension ChartDataViewModel {
    static var mock: ChartDataViewModel {
        let data = [
            Stock(name: "AAPL", volume: 1000, date: Date.toDate(date: "2023-01-01")!, open: 100, close: 100, high: 100, low: 100),
            Stock(name: "AAPL", volume: 1000, date: Date.toDate(date: "2023-01-02")!, open: 100, close: 119, high: 100, low: 100),
            Stock(name: "AAPL", volume: 1000, date: Date.toDate(date: "2023-01-03")!, open: 100, close: 120, high: 100, low: 100),
            Stock(name: "AAPL", volume: 1000, date: Date.toDate(date: "2023-01-04")!, open: 100, close: 128, high: 100, low: 100),
            Stock(name: "AAPL", volume: 1000, date: Date.toDate(date: "2023-01-05")!, open: 100, close: 150, high: 100, low: 100),
            Stock(name: "AAPL", volume: 1000, date: Date.toDate(date: "2023-01-06")!, open: 100, close: 120, high: 100, low: 100),
            Stock(name: "AAPL", volume: 1000, date: Date.toDate(date: "2023-01-07")!, open: 100, close: 190, high: 100, low: 100),
            Stock(name: "AAPL", volume: 1000, date: Date.toDate(date: "2023-01-08")!, open: 100, close: 104, high: 100, low: 100),
            Stock(name: "AAPL", volume: 1000, date: Date.toDate(date: "2023-01-09")!, open: 100, close: 109, high: 100, low: 100),
            Stock(name: "AAPL", volume: 1000, date: Date.toDate(date: "2023-01-10")!, open: 100, close: 108, high: 100, low: 100),
            Stock(name: "AAPL", volume: 1000, date: Date.toDate(date: "2023-01-11")!, open: 100, close: 100, high: 100, low: 100),
            Stock(name: "AAPL", volume: 1000, date: Date.toDate(date: "2023-01-12")!, open: 100, close: 190, high: 100, low: 100),
            Stock(name: "AAPL", volume: 1000, date: Date.toDate(date: "2023-01-13")!, open: 100, close: 175, high: 100, low: 100),
            Stock(name: "AAPL", volume: 1000, date: Date.toDate(date: "2023-01-14")!, open: 100, close: 100, high: 100, low: 100),
            Stock(name: "AAPL", volume: 1000, date: Date.toDate(date: "2023-01-15")!, open: 100, close: 101, high: 100, low: 100),
        ]
        return ChartDataViewModel(stocks: data,
                                  zoom: 0...30,
                                  minPrice: 0,
                                  maxPrice: 200,
                                  movingAverage: 150)
    }
}
