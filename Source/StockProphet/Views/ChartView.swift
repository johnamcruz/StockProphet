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
            GeometryReader { reader in
                if viewModel.type == .linear {
                    LinearChartView(viewModel: viewModel.data,
                                    width: reader.size.width,
                                    height: reader.size.height)
                } else {
                    CandleStickChartView(stocks: viewModel.stocks,
                                         width: reader.size.width,
                                         height: reader.size.height,
                                         startDate: viewModel.zoomDate,
                                         endDate: viewModel.selectedDate)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Picker("Filter:", selection: $viewModel.timePeriod) {
                    ForEach (TimePeriod.allCases, id: \.rawValue) { period in
                        Text(period.title)
                            .tag(period)
                    }
                }
                .pickerStyle(.segmented)
                .labelsHidden()
            }
            
            ToolbarItem(placement: .principal) {
                Picker("Type", selection: $viewModel.type) {
                    ForEach(ChartType.allCases, id: \.rawValue) { type in
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
    ChartView(viewModel: ChartViewModel(stocks: []))
}
