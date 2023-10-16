//
//  MockStockService.swift
//  StockProphet
//
//  Created by John M Cruz on 10/15/23.
//

import Foundation
import Algorithms

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
                
                for row in rows {
                    group.addTask {
                        try self.parseStockRow(row: row)
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
    
    func parseStockRow(row: String) throws -> Stock {
        if row.isEmpty {
            throw StockServiceError.BadData
        }
        let columns = row.components(separatedBy: MockStockService.comma)
        guard columns.count > 0 else {
            throw StockServiceError.BadData
        }
        return Stock(name: columns[6],
                     volume: Int(columns[5]) ?? 0,
                     date: Date.toDate(date: columns[0]) ?? Date(),
                     open: Decimal(string: columns[1]) ?? 0,
                     close: Decimal(string: columns[4]) ?? 0,
                     high: Decimal(string: columns[2]) ?? 0,
                     low: Decimal(string: columns[3]) ?? 0)
    }
}

extension Date {
    static func toDate(date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'"
        return dateFormatter.date(from: date)
    }
}
