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
                    .foregroundStyle(.blue)
                    
                    LineMark(
                        x: .value("date", stock.date),
                        y: .value("price", stock.prediction ?? 0),
                        series: .value("Prediction", stock.name)
                    )
                    .foregroundStyle(.orange)
                    .lineStyle(StrokeStyle(lineWidth: 3, dash: [5, 10]))
                    
                    if let hoverDate {
                        RuleMark(x: .value("Date", hoverDate))
                            .foregroundStyle(.gray)
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
                AxisMarks(values: .automatic(desiredCount: 12))
            }
            .chartLegend(spacing: 30)
            .chartOverlay { proxy in
                Color.clear
                    .onContinuousHover { phase in
                        switch phase {
                        case let .active(location):
                            hoverDate = proxy.value(atX: location.x, as: Date.self)
                        case .ended:
                            hoverDate = nil
                        }
                    }
            }
            .frame(width: Constants.dataPointWidth * CGFloat(viewModel.stocks.count))
        }
        .frame(width: width, height: height)
        .padding()
    }
}

#Preview {
    LinearChartView(viewModel: ChartDataViewModel.mock,
                    width: 100,
                    height: 100)
}
