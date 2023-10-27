//
//  StockForecastingService.swift
//  StockProphet
//
//  Created by John M Cruz on 10/25/23.
//

import Foundation
import CoreML

enum StockForecastingServiceError: Error {
    case modelLoadingError
}

protocol StockForecastingServiceable {
    func predict(original: [Stock]) async throws -> [Stock]
}

class StockForecastingService: StockForecastingServiceable {
    var model: StockForecaster?
    
    init() {
        let config = MLModelConfiguration()
        self.model = try? StockForecaster(configuration: config)
    }
    
    func predict(original: [Stock]) async throws -> [Stock] {
        guard let model = self.model else {
            throw StockForecastingServiceError.modelLoadingError
        }
        
        let input = StockForecasterInput(lstm_input: try get60DayForecast(original: original))
        let output = try await model.prediction(input: input)
        let results = output.Identity.toDoubleArray().inverseMinMaxScaler(featureRange: (-1, 1), originalMinMax: (0,1))
        return []
    }
    
    private func get60DayForecast(original: [Stock]) throws -> MLMultiArray {
        let last60days = original.suffix(60)
        let scaled = last60days.map{ $0.close }.minMaxScaler(featureRange: (0,1))
        var array = try MLMultiArray(shape: [1, 60, 1], dataType: .float32)
        
        let ptr = UnsafeMutablePointer<Double>(OpaquePointer(array.dataPointer))
        
        let channelStride = array.strides[0].intValue
        let rowStride = array.strides[1].intValue
        let columnStride = array.strides[2].intValue
        
        @inline(__always) func offset(_ channel: Int, _ y: Int, _ x: Int) -> Int {
            return channel*channelStride + y*rowStride + x*columnStride
        }
        
        for (index, value) in scaled.enumerated() {
            ptr[offset(0, index, 0)] = value
        }
        
        return array
    }
}
