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
    var filterSelection: String = ""
    
    init(stocks: [Stock], filterSelection: String = "") {
        self.stocks = stocks
        self.filterSelection = filterSelection
    }
}
