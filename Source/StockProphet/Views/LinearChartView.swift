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
    
    var body: some View {
        ScrollView(.horizontal) {
            Chart {
                ForEach(viewModel.stocks) { stock in
                    LineMark(
                        x: .value("date", stock.date),
                        y: .value("price", stock.close),
                        series: .value("Actual", stock.name)
                    )
                    
                    LineMark(
                        x: .value("date", stock.date),
                        y: .value("price", stock.prediction ?? 0),
                        series: .value("Prediction", stock.name)
                    )
                    .foregroundStyle(.orange)
                    .lineStyle(StrokeStyle(lineWidth: 3, dash: [5, 10]))
                    
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
            .chartXScale(domain: viewModel.startDate...viewModel.endDate)
            .chartYScale(domain: viewModel.minPrice...viewModel.maxPrice)
            .chartXAxisLabel("Date")
            .chartXAxis {
                AxisMarks(values: .automatic(desiredCount: 12))
            }
            .chartYAxisLabel("Stock Price")
            .chartYAxis {
                AxisMarks(preset: .extended, position: .leading, values: .automatic(desiredCount: 12))
            }
            .chartLegend(spacing: 30)
            .frame(width: Constants.dataPointWidth * CGFloat(viewModel.stocks.count))
        }
        .frame(width: width, height: height)
        .chartXSelection(value: $hoverDate)
        .padding()
    }
}

#Preview {
    LinearChartView(viewModel: ChartDataViewModel.mock,
                    width: 100,
                    height: 100)
}
