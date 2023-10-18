//
//  CandleStickChartView.swift
//  StockProphet
//
//  Created by John M Cruz on 10/15/23.
//

import SwiftUI
import Charts

struct CandleStickChartView: View {
    let viewModel: ChartDataViewModel
    
    @State var hoverDate: Date?
    
    var body: some View {
        Chart {
            ForEach(viewModel.stocks) { stock in
                CandlestickMark(
                    x: .value("date", stock.date),
                    low: .value("low", stock.low),
                    high: .value("high", stock.high),
                    open: .value("open", stock.open),
                    close: .value("close", stock.close)
                )
                .foregroundStyle(.green)
                
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
        .chartXScale(domain: viewModel.zoom)
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
        .chartScrollTargetBehavior(.valueAligned(unit: 1))
    }
}

#Preview {
    CandleStickChartView(viewModel: ChartDataViewModel.mock)
}


struct CandlestickMark<X: Plottable, Y: Plottable>: ChartContent {
    let x: PlottableValue<X>
    let low: PlottableValue<Y>
    let high: PlottableValue<Y>
    let open: PlottableValue<Y>
    let close: PlottableValue<Y>
    
    init(
        x: PlottableValue<X>,
        low: PlottableValue<Y>,
        high: PlottableValue<Y>,
        open: PlottableValue<Y>,
        close: PlottableValue<Y>
    ) {
        self.x = x
        self.low = low
        self.high = high
        self.open = open
        self.close = close
    }
    
    var body: some ChartContent {
        RectangleMark(x: x, yStart: low, yEnd: high, width: 4)
        RectangleMark(x: x, yStart: open, yEnd: close, width: 16)
            .foregroundStyle(.red)
    }
}
