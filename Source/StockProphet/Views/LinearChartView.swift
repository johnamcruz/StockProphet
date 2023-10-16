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
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        ScrollView(.horizontal) {
            Chart {
                ForEach(stocks) { stock in
                    LineMark(
                        x: .value("date", stock.date),
                        y: .value("price", stock.close),
                        series: .value("Actual", stock.name)
                    )
                    .foregroundStyle(.blue)
                }
                
                ForEach(stocks) { stock in
                    LineMark(
                        x: .value("date", stock.date),
                        y: .value("price", stock.prediction ?? 0),
                        series: .value("Prediction", stock.name)
                    )
                    .foregroundStyle(.green)
                    .lineStyle(StrokeStyle(lineWidth: 3, dash: [5, 10]))
                }
                
                RuleMark(
                    y: .value("Threshold", 100)
                )
                .foregroundStyle(.red)
            }
            //.chartYScale(domain: Constants.minYScale...Constants.maxYScale)
            .chartYAxis() {
                AxisMarks(position: .leading)
            }
            .frame(width: width, height: height)
        }
        .padding()
    }
}

#Preview {
    LinearChartView(width: 400, height: 400)
}
