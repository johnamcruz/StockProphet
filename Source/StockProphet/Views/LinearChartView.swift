//
//  LinearChartView.swift
//  StockProphet
//
//  Created by John M Cruz on 10/15/23.
//

import SwiftUI
import Charts

struct LinearChartView: View {
    let viewModel: ChartDataViewModel
    
    @State var hoverDate: Date?
    
    let linearGradient = LinearGradient(gradient: Gradient(colors: [Color.forestGreen.opacity(0.4),
                                                                    Color.forestGreen.opacity(0)]),
                                        startPoint: .top,
                                        endPoint: .bottom)
    
    var body: some View {
        Chart {
            ForEach(viewModel.stocks) { stock in
                LineMark(
                    x: .value("date", stock.date),
                    y: .value("price", stock.close)
                )
                .foregroundStyle(.green)
                
                AreaMark(
                    x: .value("date", stock.date),
                    y: .value("price", stock.close)
                )
                .foregroundStyle(linearGradient)
                
                if let hoverDate {
                    RuleMark(x: .value("Date", hoverDate))
                        .foregroundStyle(Color.gray.opacity(0.3))
                        .offset(yStart: -10)
                        .zIndex(-1)
                        .annotation(
                            position: .top, spacing: 0,
                            overflowResolution: .init(
                                x: .fit(to: .chart),
                                y: .disabled)) {
                            Text(hoverDate.formatted())
                        }
                }
            }
            
            RuleMark(
                y: .value("Threshold", viewModel.movingAverage)
            )
            .foregroundStyle(.red)
        }
        //.chartXScale(range: viewModel.zoom)
        .chartYScale(domain: viewModel.minPrice...viewModel.maxPrice)
        .chartXAxisLabel("Date")
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 12))
        }
        .chartYAxisLabel("Stock Price")
        .chartYAxis {
            AxisMarks(preset: .extended, position: .leading, values: .automatic(desiredCount: 12))
        }
        .chartXSelection(value: $hoverDate)
        .chartScrollableAxes(.horizontal)
    }
}

#Preview {
    LinearChartView(viewModel: ChartDataViewModel.mock)
}
