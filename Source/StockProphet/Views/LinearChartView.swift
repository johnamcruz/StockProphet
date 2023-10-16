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
                    y: .value("price", stock.close),
                    series: .value("Actual", stock.name)
                )
                .foregroundStyle(.blue)
                PointMark(
                    x: .value("date", stock.date),
                    y: .value("price", stock.close)
                )
            }
            
            ForEach(stocks) { stock in
                LineMark(
                    x: .value("date", stock.date),
                    y: .value("price", stock.prediction ?? 0),
                    series: .value("Prediction", stock.name)
                )
                .foregroundStyle(.green)
            }
            
            RuleMark(
                y: .value("Threshold", 100)
            )
            .foregroundStyle(.red)
        }
    }
}

#Preview {
    LinearChartView()
}
