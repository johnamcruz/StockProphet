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
    var stocks: [Stock] = []
    var timePeriod: TimePeriod = .FiveYear
    var type: ChartType = .linear
    var selectedDate: Date = Date.toDate(date: "2018-02-07")!
    var isLoading: Bool = false
    
    let service = MockStockService()
    
    var zoom: ClosedRange<Date> {
        var start: Date = Date()
        switch timePeriod {
            /*case .OneDay:
             return oneDayAgo*/
        case .OneWeek:
            start = Calendar.current.date(byAdding: .day, value: -7, to: selectedDate)!
        case .OneMonth:
            start = Calendar.current.date(byAdding: .day, value: -30, to: selectedDate)!
        case .ThreeMonths:
            start = Calendar.current.date(byAdding: .day, value: -90, to: selectedDate)!
        case .OneYear:
            start = Calendar.current.date(byAdding: .day, value: -365, to: selectedDate)!
        case .FiveYear:
            start = Calendar.current.date(byAdding: .day, value: -(365*5), to: selectedDate)!
        }
        return start...selectedDate
    }
    
    var maxPrice: Double {
        stocks.reduce(Double.zero) { max($0, $1.close) } + 5
    }
    
    var minPrice: Double {
        stocks.reduce(Double.zero) { min($0, $1.close) } - 5
    }
    
    var movingAverage: Double {
        let sum = stocks.reduce(Double.zero) { $0 + $1.close }
        return (sum / 10)
    }
    
    var data: ChartDataViewModel {
        ChartDataViewModel(stocks: stocks,
                           zoom: zoom,
                           minPrice: minPrice,
                           maxPrice: maxPrice,
                           movingAverage: movingAverage)

    }
    
    func load(ticker: String) async {
        isLoading = true
        await service.load()
        try? await runPrediction()
        isLoading = false
    }
    
    func runPrediction() async throws {
        do {
            let prediction = try StockPredictionService()
            let original = service.getAllStocks()
            stocks = try await prediction.predict(original: original).sorted(by: \.date)
        } catch {
            print("predictions failed")
        }
    }
}
