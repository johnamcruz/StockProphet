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
    var movingAverages: [MovingAverage] = []
    var timePeriod: TimePeriod = .OneDay
    var type: ChartType = .linear
    var selectedDate: Date = Date().previousDate
    var isLoading: Bool = false
    var showPrediction: Bool = false
    
    let service = StockService()
    let prediction = try? StockPredictionService()
    
    var zoom: ClosedRange<Date> {
        var start: Date = Date()
        switch timePeriod {
        case .OneDay:
            start = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate)!
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
        return (stocks.map{ $0.close }.max() ?? 0) + 10
    }
    
    var minPrice: Double {
        return (stocks.map{ $0.close }.min() ?? 0) - 10
    }
    
    var data: ChartDataViewModel {
        ChartDataViewModel(stocks: stocks,
                           zoom: zoom,
                           price: minPrice...maxPrice,
                           movingAverages: movingAverages,
                           showPrediction: showPrediction)

    }
    
    func load(ticker: String) async {
        isLoading = true
        async let original = service.load(ticker: ticker, period: timePeriod, from: zoom.lowerBound, to: zoom.upperBound)
        try? await runPrediction(original: original)
        isLoading = false
    }
    
    func generateMovingAverage(ticker: String) async {
        movingAverages = await service.getMovingAverage(ticker: ticker, period: timePeriod)
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
