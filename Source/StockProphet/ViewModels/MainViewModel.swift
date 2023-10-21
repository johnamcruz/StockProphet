//
//  MainViewModel.swift
//  StockProphet
//
//  Created by John M Cruz on 10/15/23.
//

import Foundation
import SwiftUI

@Observable
class MainViewModel {
    var searchQuery: String = ""
    var companies: [Company] = []
    
    let service = CompanyService()
    
    var searchResults: [Company] {
        searchQuery.isEmpty ? companies : companies.filter({ $0.name.contains(searchQuery) || searchQuery.contains($0.ticker) })
    }
    
    func load() async {
        if let date = Calendar.current.date(byAdding: .day, value: -1, to: Date()) {
            companies = await service.load(date: date)
        }
    }
}
