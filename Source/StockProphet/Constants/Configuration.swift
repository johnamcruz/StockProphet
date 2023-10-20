//
//  Configuration.swift
//  StockProphet
//
//  Created by John M Cruz on 10/20/23.
//

import Foundation

class Configuration {
    static var apiKey: String {
        guard let filePath = Bundle.main.path(forResource: "apiKey", ofType: "text") else {
            return ""
        }
        do {
            return try String(contentsOfFile: filePath)
        } catch {
            debugPrint(error)
            return ""
        }
    }
}
