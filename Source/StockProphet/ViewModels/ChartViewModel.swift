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
    var timePeriod: TimePeriod = .OneDay
    var type: ChartType = .linear
    var selectedDate: Date = Date.toDate(date: "2018-01-05") ?? Date()
    
    init(stocks: [Stock]) {
        self.stocks = stocks
    }
    
    func updateTimePeriod() {
        var stocks: [Stock] = []
        do {
            let previousDate = try getRange()
            stocks = stocks.filter { $0.date >= previousDate && $0.date <= selectedDate }
        } catch {
            
        }
        self.stocks = stocks
    }
    
    func getRange() throws -> Date {
        // Calculate the start and end dates for each time period.
        guard let oneDayAgo = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate),
        let oneWeekAgo = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: selectedDate),
        let oneMonthAgo = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate),
        let threeMonthAgo = Calendar.current.date(byAdding: .month, value: -3, to: selectedDate),
        let oneYearAgo = Calendar.current.date(byAdding: .year, value: -1, to: selectedDate),
              let fiveYearsAgo = Calendar.current.date(byAdding: .day, value: -5, to: selectedDate) else {
            throw ChartViewModelError.dateRangeError
        }

        switch timePeriod {
        case .OneDay:
            return oneDayAgo
        case .OneWeek:
            return oneWeekAgo
        case .OneMonth:
            return oneMonthAgo
        case .ThreeMonths:
            return threeMonthAgo
        case .OneYear:
            return oneYearAgo
        case .FiveYear:
            return fiveYearsAgo
        }
    }
}
