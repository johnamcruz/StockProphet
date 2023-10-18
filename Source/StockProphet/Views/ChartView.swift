//
//  ChartView.swift
//  StockProphet
//
//  Created by John M Cruz on 10/15/23.
//

import SwiftUI

struct ChartView: View {
    @State private var viewModel = ChartViewModel()
    
    let ticker: String
    
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
        .task {
            await viewModel.load(ticker: ticker)
        }
        .overlay {
            if viewModel.isLoading {
                Rectangle()
                    .fill(Color.secondary.opacity(0.1))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .overlay {
                        ProgressView("Loading...")
                            .progressViewStyle(.circular)
                            .controlSize(.extraLarge)
                            .padding()
                    }
            }
        }
    }
}

#Preview {
    ChartView(ticker: "AAPL")
}
