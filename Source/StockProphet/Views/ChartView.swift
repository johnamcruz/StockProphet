//
//  ChartView.swift
//  StockProphet
//
//  Created by John M Cruz on 10/15/23.
//

import SwiftUI

struct ChartView: View {
    @State private var viewModel = ChartViewModel()
    @State private var currentZoom = 0.0
    @State private var totalZoom = 1.0
    
    let ticker: String
    
    var magnification: some Gesture {
        MagnifyGesture()
            .onChanged { value in
                currentZoom = value.magnification - 1
            }
            .onEnded { value in
                totalZoom += currentZoom
                currentZoom = 0
                if let period = TimePeriod(rawValue: Int(totalZoom)) {
                    viewModel.timePeriod = period
                }
            }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.type == .linear {
                LinearChartView(viewModel: viewModel.data)
                    .gesture(magnification)
            } else {
                CandleStickChartView(viewModel: viewModel.data)
                    .gesture(magnification)
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
            
            ToolbarItem(placement: .secondaryAction) {
                Toggle(isOn: $viewModel.showPrediction) {
                    Image(systemName: Images.upDown)
                }
                .labelsHidden()
                .toggleStyle(.button)
            }
        }
        .task(id: viewModel.timePeriod) {
            await viewModel.load(ticker: ticker)
            await viewModel.generateMovingAverage(ticker: ticker)
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
