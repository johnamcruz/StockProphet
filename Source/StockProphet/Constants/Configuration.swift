//
//  Configuration.swift
//  StockProphet
//
//  Created by John M Cruz on 10/20/23.
//

import Foundation

class Configuration {
    static var apiKey: String {
        guard let filePath = Bundle.main.path(forResource: "apikey", ofType: "txt") else {
            return ""
        }
        do {
            return try String(contentsOfFile: filePath).replacingOccurrences(of: "\n", with: "")
        } catch {
            debugPrint(error)
            return ""
        }
    }
}
