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
    
    @State private var hoverDate: Date?
    @State private var position: Date = Date()
    
    let linearGradient = LinearGradient(gradient: Gradient(colors: [Color.forestGreen.opacity(0.4),
                                                                    Color.forestGreen.opacity(0)]),
                                        startPoint: .top,
                                        endPoint: .bottom)
    
    var body: some View {
        Chart {
            ForEach(viewModel.stocks) { stock in
                LineMark(
                    x: .value("date", stock.date),
                    y: .value("price", stock.close),
                    series: .value("type", "Actual")
                )
                .foregroundStyle(.green)
                //.symbol(.circle)
                //.symbolSize(Constants.dotSize)
                
                if viewModel.showPrediction {
                    LineMark(
                        x: .value("date", stock.date),
                        y: .value("prediction", stock.prediction ?? 0),
                        series: .value("type", "Prediction")
                    )
                    .foregroundStyle(.orange)
                }
                
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
                            position: .overlay, spacing: 0,
                            overflowResolution: .init(x: .fit(to: .chart),y: .disabled)) {
                                Text(hoverDate.formatted())
                            }
                }
            }
            
            ForEach(viewModel.movingAverages) { average in
                LineMark(
                    x: .value("date", average.date),
                    y: .value("price", average.value)
                )
                .foregroundStyle(.red)
            }
        }
        //.chartXScale(domain: viewModel.zoom)
        .chartYScale(domain: viewModel.price)
        .chartXAxisLabel("Date")
        .chartXAxis {
            if viewModel.timePeriod == .OneDay {
                AxisMarks(values: .stride(by: .hour)) { date in
                    AxisValueLabel(format: .dateTime.hour())
                }
            } else if viewModel.timePeriod == .OneWeek {
                AxisMarks(values: .stride(by: .day)) { date in
                    AxisValueLabel(format: .dateTime.month().day())
                }
            } else {
                AxisMarks(values: .stride(by: .month)) { date in
                    AxisValueLabel(format: .dateTime.month().year(.twoDigits))
                }
            }
        }
        .chartYAxisLabel("Stock Price")
        .chartYAxis {
            AxisMarks(preset: .extended, position: .leading, values: .automatic(desiredCount: 12))
        }
        .chartXSelection(value: $hoverDate)
        .chartScrollableAxes(.horizontal)
        .chartScrollPosition(x: $position)
        .chartScrollTargetBehavior(.valueAligned(unit: 1))
    }
}

#Preview {
    LinearChartView(viewModel: ChartDataViewModel.mock)
}
