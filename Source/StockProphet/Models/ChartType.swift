//
//  ChartType.swift
//  StockProphet
//
//  Created by John M Cruz on 10/15/23.
//

import Foundation

enum ChartType: String, CaseIterable {
    case linear
    case candleStick
    
    var icon: String {
        switch self {
        case .linear:
            "chart.line.uptrend.xyaxis"
        default:
            "chart.bar.fill"
        }
    }
}
