//
//  LinearChartView.swift
//  StockProphet
//
//  Created by John M Cruz on 10/15/23.
//

import SwiftUI
import Charts

struct LinearChartView: View {
    var stocks: [Stock] = []
    
    var body: some View {
        Chart {
            ForEach(stocks) { stock in
                LineMark(
                    x: .value("date", stock.date),
                    y: .value("price", stock.close)
                )
                PointMark(
                    x: .value("date", stock.date),
                    y: .value("price", stock.close)
                )
            }
        }
    }
}

#Preview {
    LinearChartView()
}
