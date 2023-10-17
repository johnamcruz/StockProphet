//
//  ChartDataViewModel.swift
//  StockProphet
//
//  Created by John M Cruz on 10/16/23.
//

import Foundation

struct ChartDataViewModel {
    let stocks: [Stock]
    let startDate: Date
    let endDate: Date
    let minPrice: Double
    let maxPrice: Double
    let movingAverage: Double
}

extension ChartDataViewModel {
    static var mock: ChartDataViewModel {
        ChartDataViewModel(stocks: [],
                           startDate: Date(),
                           endDate: Date(),
                           minPrice: 0,
                           maxPrice: 0,
                           movingAverage: 0)
    }
}
