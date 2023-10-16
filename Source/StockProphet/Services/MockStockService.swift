//
//  MockStockService.swift
//  StockProphet
//
//  Created by John M Cruz on 10/15/23.
//

import Foundation
import Algorithms
import CodableCSV

enum StockServiceError: Error {
    case BadData
}

class MockStockService: StockServiceable {
    static let newline = "\n"
    static let comma = ","
    var stocks: [Stock] = []
    
    func load() async {
        guard let filePath = Bundle.main.path(forResource: "all_stocks_5yr", ofType: "csv") else {
            return
        }
        
        do {
            stocks = try await withThrowingTaskGroup(of: Stock.self, returning: [Stock].self) { group in
                let rows = try getStockRows(filePath: filePath)
                let decoder = CSVDecoder()
                for row in rows {
                    group.addTask {
                        guard let data = row.data(using: .utf8) else {
                            throw StockServiceError.BadData
                        }
                        return try decoder.decode(Stock.self, from: data)
                    }
                }
                
                var stocks: [Stock] = []
                for try await stock in group {
                    stocks.append(stock)
                }
                return stocks
            }
            
        } catch {
            // contents could not be loaded
            print("data cannot be loaded")
        }
    }
    
    func getStock(ticker: String) -> [Stock] {
        stocks.filter{ $0.name == ticker }
    }
    
    func getAllStocks() -> [Stock] {
        stocks
    }
    
    func getStockRows(filePath: String) throws -> [String] {
        let contents = try String(contentsOfFile: filePath)
        var rows = contents.components(separatedBy: MockStockService.newline)
        rows.removeFirst()
        return rows
    }
}
