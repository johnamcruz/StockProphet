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
    
    var stocks: [Stock] = []
    var isLoading: Bool = false
    var searchQuery: String = ""
    
    func load() async {
        isLoading = true
        await service.load()
        stocks = service.getAllStocks()
        try? await runPrediction()
        isLoading = false
    }
    
    func getChartViewModel(symbol: String) -> ChartViewModel {
        ChartViewModel(stocks: stocks.filter { $0.name == symbol })
    }
    
    func runPrediction() async throws {
        do {
            let prediction = try StockPredictionService()
            stocks = try await prediction.predict(original: stocks)
        } catch {
            print("predictions failed")
        }
    }
}
