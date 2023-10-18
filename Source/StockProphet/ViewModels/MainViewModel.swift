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
    
    var searchResults: [Company] {
        searchQuery.isEmpty ? Company.all : Company.all.filter({ $0.name.contains(searchQuery) || searchQuery.contains($0.ticker) })
    }
}
