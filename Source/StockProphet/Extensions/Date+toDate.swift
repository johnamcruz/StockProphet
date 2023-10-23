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

extension Date {
    var weekDay: Date {
      // Get the current weekday.
      let weekday = Calendar.current.component(.weekday, from: self)

      // If the current weekday is Saturday or Sunday, return Monday.
      if weekday == 7 || weekday == 1 {
          return Calendar.current.date(byAdding: .day, value: 6, to: self)!
      } else {
        return Date()
      }
    }
}
