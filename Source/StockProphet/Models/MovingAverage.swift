//
//  MovingAverage.swift
//  StockProphet
//
//  Created by John M Cruz on 10/21/23.
//

import Foundation
import PolygonClient

struct MovingAverage: Identifiable {
    let date: Date
    let value: Double
    
    var id: Date {
        date
    }
}

extension SimpleMovingAverageValue {
    func toMovingAverage() -> MovingAverage {
        MovingAverage(date: self.timestamp, value: self.value)
    }
}
