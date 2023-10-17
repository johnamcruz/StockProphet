//
//  ChartViewModel.swift
//  StockProphet
//
//  Created by John M Cruz on 10/15/23.
//

import Foundation

enum ChartViewModelError: Error {
    case dateRangeError
}

@Observable
class ChartViewModel {
    var stocks: [Stock]
    var timePeriod: TimePeriod = .FiveYear
    var type: ChartType = .linear
    var zoom: ClosedRange<Int> {
        
        switch timePeriod {
            /*case .OneDay:
             return oneDayAgo*/
        case .OneWeek:
            return 0...7
        case .OneMonth:
            return 0...30
        case .ThreeMonths:
            return 0...90
        case .OneYear:
            return 0...365
        case .FiveYear:
            return 0...(365*5)
        }
    }
    var maxPrice: Double {
        stocks.reduce(Double.zero) { max($0, $1.close) } + 5
    }
    var minPrice: Double {
        stocks.reduce(Double.zero) { min($0, $1.close) } - 5
    }
    
    init(stocks: [Stock]) {
        self.stocks = stocks
    }
    
    var movingAverage: Double {
        let sum = stocks.reduce(Double.zero) { $0 + $1.close }
        return (sum / Double(zoom.upperBound))
    }
    
    var data: ChartDataViewModel {
        ChartDataViewModel(stocks: stocks,
                           zoom: 0...30,
                           minPrice: minPrice,
                           maxPrice: maxPrice,
                           movingAverage: movingAverage)

    }
}
