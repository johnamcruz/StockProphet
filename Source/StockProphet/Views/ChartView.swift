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
        VStack(spacing: 0) {
            if viewModel.type == .linear {
                LinearChartView(viewModel: viewModel.data)
            } else {
                CandleStickChartView(viewModel: viewModel.data)
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Picker("Filter:", selection: $viewModel.timePeriod) {
                    ForEach (TimePeriod.allCases) { period in
                        Text(period.title)
                            .tag(period)
                    }
                }
                .pickerStyle(.segmented)
                .labelsHidden()
            }
            
            ToolbarItem(placement: .principal) {
                Picker("Type", selection: $viewModel.type) {
                    ForEach(ChartType.allCases) { type in
                        Image(systemName: type.icon)
                            .tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .labelsHidden()
            }
        }
    }
}

#Preview {
    ChartView(viewModel: ChartViewModel(stocks: ChartDataViewModel.mock.stocks))
}
