//
//  MainViewModel.swift
//  StockProphet
//
//  Created by John M Cruz on 10/15/23.
//

import Foundation
import SwiftUI

@Observable
class MainViewModel {
    let service = MockStockService()
    
    var isLoading: Bool = false
    var searchQuery: String = ""
    
    func load() async {
        isLoading = true
        await service.load()
        isLoading = false
    }
    
    func getChartViewModel(symbol: String) -> ChartViewModel {
        ChartViewModel(stocks: service.getAllStocks())
    }
}
