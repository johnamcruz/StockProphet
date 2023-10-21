//
//  StockPredictionService.swift
//  StockProphet
//
//  Created by John M Cruz on 10/15/23.
//

import Foundation
import CoreML
import Algorithms

enum StockPredictionServiceError: Error {
    case emptyOriginalData
}

protocol StockPredictionServiceable {
    func predict(original: Stock) async throws -> Stock
    func predict(original: [Stock]) async throws -> [Stock]
}

class StockPredictionService: StockPredictionServiceable {
    private static let chunkSize = 10
    private let model: StockForecastingModel
    
    init() throws {
        let config = MLModelConfiguration()
        self.model = try StockForecastingModel(configuration: config)
    }
    
    func predict(original: Stock) async throws -> Stock {
        var output = original
        let result = try await model.prediction(input: original.toInput())
        output.prediction = result.close
        return output
    }
    
    func predict(original: [Stock]) async throws -> [Stock] {
        guard original.count > 0 else {
            throw StockPredictionServiceError.emptyOriginalData
        }
        
        return try await withThrowingTaskGroup(of: Stock.self, returning: [Stock].self) { group in
            let numberOfChunks = Int(ceil(Double(original.count) / Double(StockPredictionService.chunkSize)))
            for stockGroup in original.chunks(ofCount: numberOfChunks) {
                for stock in stockGroup {
                    group.addTask {
                        try await self.predict(original: stock)
                    }
                }
            }
            
            var results: [Stock] = []
            for try await stock in group {
                results.append(stock)
            }
            return results
        }
    }
    
    
}
