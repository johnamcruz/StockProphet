//
//  ChartType.swift
//  StockProphet
//
//  Created by John M Cruz on 10/15/23.
//

import Foundation

enum ChartType: String, CaseIterable, Identifiable {
    case linear
    case candleStick
    
    var icon: String {
        switch self {
        case .linear:
            "chart.line.uptrend.xyaxis"
        case .candleStick:
            "chart.bar.fill"
        }
    }
    
    var id: Self {
        return self
    }
}
