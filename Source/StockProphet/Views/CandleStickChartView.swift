//
//  CandleStickChartView.swift
//  StockProphet
//
//  Created by John M Cruz on 10/15/23.
//

import SwiftUI
import Charts

struct CandleStickChartView: View {
    var stocks: [Stock] = []
    
    var body: some View {
        Chart {
            ForEach(stocks) { stock in
                CandlestickMark(
                    x: .value("date", stock.date),
                    low: .value("low", stock.low),
                    high: .value("high", stock.high),
                    open: .value("open", stock.open),
                    close: .value("close", stock.close)
                )
                .foregroundStyle(.green)
            }
        }
    }
}

#Preview {
    CandleStickChartView()
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
