//
//  StockForecastingService.swift
//  StockProphet
//
//  Created by John M Cruz on 10/25/23.
//

import Foundation

protocol StockForecastingServiceable {
    func predict(original: Stock) async throws -> Stock
    func predict(original: [Stock]) async throws -> [Stock]
}
