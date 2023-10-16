//
//  ChartView.swift
//  StockProphet
//
//  Created by John M Cruz on 10/15/23.
//

import SwiftUI

struct ChartView: View {
    var stocks: [Stock] = []
    
    var body: some View {
        TabView {
            LinearChartView(stocks: stocks)
            CandleStickChartView(stocks: stocks)
        }
    }
}

#Preview {
    ChartView(stocks: [])
}
