//
//  TimePeriod.swift
//  StockProphet
//
//  Created by John M Cruz on 10/15/23.
//

import Foundation

enum TimePeriod: Int, CaseIterable,Identifiable {
    case OneDay
    case OneWeek
    case OneMonth
    case ThreeMonths
    case OneYear
    case FiveYear
    
    var id: Self {
        return self
    }
    
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
