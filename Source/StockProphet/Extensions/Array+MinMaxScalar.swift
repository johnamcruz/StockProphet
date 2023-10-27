//
//  Array+MinMaxScalar.swift
//  StockProphet
//
//  Created by John M Cruz on 10/26/23.
//

import Foundation

extension Array where Element == Double {
    func minMaxScaler(featureRange: (Double, Double)) -> [Double] {
        let min = self.min() ?? 0.0
        let max = self.max() ?? 1.0
        let scaledData = self.map { value in
            return (value - min) / (max - min) * (featureRange.1 - featureRange.0) + featureRange.0
        }
        return scaledData
    }
}
