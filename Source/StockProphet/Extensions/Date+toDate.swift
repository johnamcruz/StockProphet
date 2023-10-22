//
//  Date+toDate.swift
//  StockProphet
//
//  Created by John M Cruz on 10/20/23.
//

import Foundation

extension Date {
    static func toDate(date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: date)
    }
}

extension Date {
    var previousDate: Date {
        Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
}
