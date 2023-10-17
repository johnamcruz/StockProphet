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
    let width: CGFloat
    let height: CGFloat
    
    @State var hoverDate: Date?
    
    let linearGradient = LinearGradient(gradient: Gradient(colors: [Color.forestGreen.opacity(0.4),
                                                                    Color.forestGreen.opacity(0)]),
                                        startPoint: .top,
                                        endPoint: .bottom)
    
    var body: some View {
        ScrollView(.horizontal) {
            Chart {
                ForEach(viewModel.stocks) { stock in
                    LineMark(
                        x: .value("date", stock.date),
                        y: .value("price", stock.close)
                    )
                    .interpolationMethod(.cardinal)
                    
                    AreaMark(
                        x: .value("date", stock.date),
                        y: .value("price", stock.close)
                    )
                    .interpolationMethod(.cardinal)
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
            .aspectRatio(1, contentMode: .fit)
            .chartXScale(range: viewModel.zoom)
            .chartYScale(domain: viewModel.minPrice...viewModel.maxPrice)
            .chartXAxisLabel("Date")
            .chartXAxis {
                AxisMarks(values: .automatic(desiredCount: 12))
            }
            .chartYAxisLabel("Stock Price")
            .chartYAxis {
                AxisMarks(preset: .extended, position: .leading, values: .automatic(desiredCount: 12))
            }
        }
        .frame(width: width, height: height)
        .chartXSelection(value: $hoverDate)
        .padding()
    }
}

#Preview {
    LinearChartView(viewModel: ChartDataViewModel.mock,
                    width: 1000,
                    height: 500)
}
