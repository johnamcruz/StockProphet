//
//  ChartView.swift
//  StockProphet
//
//  Created by John M Cruz on 10/15/23.
//

import SwiftUI

struct ChartView: View {
    @Bindable var viewModel: ChartViewModel
    
    var body: some View {
        TabView {
            LinearChartView(stocks: viewModel.stocks)
            CandleStickChartView(stocks: viewModel.stocks)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Picker("Filter:", selection: $viewModel.filterSelection) {
                      Text("1D").tag("1 day")
                      Text("1W").tag("1 week")
                      Text("1M").tag("1 month")
                      Text("3M").tag("3 months")
                      Text("1Y").tag("1 year")
                      Text("5Y").tag("5 years")
                }
                .pickerStyle(.segmented)
                .labelsHidden()
            }
        }
    }
}

#Preview {
    ChartView(viewModel: ChartViewModel(stocks: []))
}
