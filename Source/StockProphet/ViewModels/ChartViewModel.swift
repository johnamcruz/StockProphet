//
//  ChartViewModel.swift
//  StockProphet
//
//  Created by John M Cruz on 10/15/23.
//

import Foundation

@Observable
class ChartViewModel {
    var stocks: [Stock]
    var timePeriod: TimePeriod = .OneDay
    var type: ChartType = .linear
    
    init(stocks: [Stock]) {
        self.stocks = stocks
    }
}
