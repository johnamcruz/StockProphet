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
        
        return []
    }
    
    func get60DayForecast(original: [Stock]) throws -> MLMultiArray {
        /**
         # Step 6: Predict Future Stock Price
         # Get the last 60 day closing price
         last_60_days = dataset[-60:]

         # Scale the data to be values between 0 and 1
         last_60_days_scaled = scaler.transform(last_60_days.reshape(-1, 1))

         # Create an empty list
         X_test = []

         # Append the past 60 days
         X_test.append(last_60_days_scaled)

         # Convert the X_test data set to a numpy array
         X_test = np.array(X_test)

         # Reshape the data
         X_test = np.reshape(X_test, (X_test.shape[0], X_test.shape[1], 1))
         */
        
        throw StockForecastingServiceError.modelLoadingError
    }
}
