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
    let service = MockStockService()
    
    var isLoading: Bool = false
    
    func load() async {
        isLoading = true
        await service.load()
        isLoading = false
    }
}
