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
        
        let input = StockForecasterInput(lstm_input: MLMultiArray())
        let output = try await model.prediction(input: input)
        
        return []
    }
}
