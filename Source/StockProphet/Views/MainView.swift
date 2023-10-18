//
//  MainView.swift
//  StockProphet
//
//  Created by John M Cruz on 10/15/23.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var companies: [Company]
    @State private var viewModel = MainViewModel()
    @State private var selection: Company.ID?

    var body: some View {
        NavigationSplitView {
            List(selection: $selection) {
                ForEach(companies) { company in
                    NavigationLink {
                        ChartView(ticker: company.ticker)
                    } label: {
                        StockTickerView(company: company)
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            deleteItem(company: company)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .searchable(text: $viewModel.searchQuery, placement: .toolbar, prompt: "Search for Stocks") {
                ForEach(viewModel.searchResults) { company in
                    Button {
                        if !companies.contains(where: { $0.ticker == company.ticker }) {
                            withAnimation {
                                modelContext.insert(company)
                            }
                        }
                    } label: {
                        Text("\(company.name)")
                    }
                }
            }
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 250, ideal: 300)
#endif
        } detail: {
            Text("Select a stock")
        }
    }
    
    private func deleteItem(company: Company) {
        if let index = companies.firstIndex(where: { $0.ticker == company.ticker }) {
            withAnimation {
                modelContext.delete(companies[index])
            }
        }
    }
}

#Preview {
    MainView()
        .modelContainer(for: Company.self, inMemory: true)
}
