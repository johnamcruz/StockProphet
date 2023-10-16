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
    case InvalidColumns
    case StockParsingFailed
}

class MockStockService: StockServiceable {
    static let newline = "\n"
    static let comma = ","
    var stocks: [Stock] = []
    
    func load() async {
        guard let filePath = Bundle.main.path(forResource: "AMZN_data", ofType: "csv") else {
            return
        }
        
        do {
            stocks = try await withThrowingTaskGroup(of: Stock?.self, returning: [Stock].self) { group in
                let rows = try getStockRows(filePath: filePath)
                
                for row in rows {
                    group.addTask {
                        do {
                            return try self.parseStockRow(row: row)
                        }
                        catch {
                            return nil
                        }
                    }
                }
                
                var stocks: [Stock] = []
                for try await stock in group {
                    if let stock = stock {
                        stocks.append(stock)
                    }
                }
                return stocks
            }
            
        } catch {
            print(error.localizedDescription)
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
            throw StockServiceError.InvalidColumns
        }
        guard let date = Date.toDate(date: columns[0]),
              let openPrice = Decimal(string: columns[1]),
              let highPrice = Decimal(string: columns[2]),
              let lowPrice = Decimal(string: columns[3]),
              let closePrice = Decimal(string: columns[4]),
              let volume = Float(columns[5]) else {
            throw StockServiceError.StockParsingFailed
        }
        return Stock(name: columns[6],
                     volume: volume,
                     date: date,
                     open: openPrice,
                     close: closePrice,
                     high: highPrice,
                     low: lowPrice)
    }
}

extension Date {
    static func toDate(date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: date)
    }
}
