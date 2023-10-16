//
//  TimePeriod.swift
//  StockProphet
//
//  Created by John M Cruz on 10/15/23.
//

import Foundation

enum TimePeriod: String, CaseIterable {
    case OneDay
    case OneWeek
    case OneMonth
    case ThreeMonths
    case OneYear
    case FiveYear
    
    var title: String {
        switch self {
        case .OneDay:
            "1D"
        case .OneWeek:
            "1W"
        case .OneMonth:
            "1M"
        case .ThreeMonths:
            "3M"
        case .OneYear:
            "1Y"
        case .FiveYear:
            "5Y"
        }
    }
}
