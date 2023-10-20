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
    private static let chunkSize = 10
    static let newline = "\n"
    static let comma = ","
    var stocks: [Stock] = []
    
    func load(ticker: String, period: TimePeriod, from: Date, to: Date) async -> [Stock] {
        let results = await load(ticker: ticker)
        return results.filter{ $0.date >= from && $0.date <= to  }
    }
    
    private func load(ticker: String) async -> [Stock] {
        guard let filePath = Bundle.main.path(forResource: "\(ticker)_data", ofType: "csv") else {
            return []
        }
        
        do {
            return try await withThrowingTaskGroup(of: Stock?.self, returning: [Stock].self) { group in
                let rows = try getStockRows(filePath: filePath)
                let numberOfChunks = Int(ceil(Double(rows.count) / Double(MockStockService.chunkSize)))
                for rowGroup in rows.chunks(ofCount: numberOfChunks) {
                    for row in rowGroup {
                        group.addTask {
                            do {
                                return try self.parseStockRow(row: row)
                            }
                            catch {
                                return nil
                            }
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
            return []
        }
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
              let openPrice = Double(columns[1]),
              let highPrice = Double(columns[2]),
              let lowPrice = Double(columns[3]),
              let closePrice = Double(columns[4]),
              let volume = Int64(columns[5]) else {
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
