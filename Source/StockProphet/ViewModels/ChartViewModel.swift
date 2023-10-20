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
        let stocks = stocks.filter{ $0.date > zoom.lowerBound && $0.date <= zoom.upperBound }
        return (stocks.map{ $0.close }.max() ?? 0) + 10
    }
    
    var minPrice: Double {
        let stocks = stocks.filter{ $0.date > zoom.lowerBound && $0.date <= zoom.upperBound }
        return (stocks.map{ $0.close }.min() ?? 0) - 10
    }
    
    var movingAverage: Double {
        //let stocks = stocks.filter{ $0.date > zoom.lowerBound && $0.date <= zoom.upperBound }
        let sum = stocks.reduce(Double.zero) { $0 + $1.close }
        let range = Calendar.current.dateComponents([.day], from: zoom.lowerBound, to: selectedDate)
        return (sum / Double(range.day ?? 1))
    }
    
    var data: ChartDataViewModel {
        ChartDataViewModel(stocks: stocks,
                           zoom: zoom,
                           price: minPrice...maxPrice,
                           movingAverage: movingAverage,
                           showPrediction: showPrediction)

    }
    
    func load(ticker: String) async {
        isLoading = true
        stocks = await service.load(ticker: ticker, period: timePeriod, from: zoom.lowerBound, to: zoom.upperBound)
        //try? await runPrediction(original: original)
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
