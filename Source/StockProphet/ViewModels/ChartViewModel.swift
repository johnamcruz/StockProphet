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
    let prediction = try? StockPredictionService()
    
    var zoom: ClosedRange<Date> {
        var start: Date = Date()
        switch timePeriod {
            /*case .OneDay:
             return oneDayAgo*/
        case .OneWeek:
            start = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: selectedDate)!
        case .OneMonth:
            start = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate)!
        case .ThreeMonths:
            start = Calendar.current.date(byAdding: .month, value: -3, to: selectedDate)!
        case .OneYear:
            start = Calendar.current.date(byAdding: .year, value: -1, to: selectedDate)!
        case .FiveYear:
            start = Calendar.current.date(byAdding: .year, value: -5, to: selectedDate)!
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
        let range = Calendar.current.dateComponents([.day], from: zoom.lowerBound, to: selectedDate)
        return (sum / Double(range.day ?? 1))
    }
    
    var data: ChartDataViewModel {
        ChartDataViewModel(stocks: stocks,
                           zoom: zoom,
                           price: minPrice...maxPrice,
                           movingAverage: movingAverage)

    }
    
    func load(ticker: String) async {
        isLoading = true
        async let original = service.load(ticker: ticker)
        try? await runPrediction(original: original)
        isLoading = false
    }
    
    func runPrediction(original: [Stock]) async throws {
        do {
            guard let prediction = prediction else {
                print("failed to load predictions")
                return
            }
            stocks = try await prediction.predict(original: original).sorted(by: \.date)
        } catch {
            print("predictions failed")
        }
    }
}
