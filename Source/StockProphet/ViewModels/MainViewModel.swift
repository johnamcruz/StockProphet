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
    var searchResults: [Company] = []
    
    let service = CompanyService()
    
    func load() async {
        if !searchQuery.isEmpty && searchQuery.count >= 3 {}
        searchResults = await service.load(query: searchQuery)
    }
}
