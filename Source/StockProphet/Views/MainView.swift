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
    @Query private var items: [StockItem]
    @State private var viewModel = MainViewModel()

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        ChartView(ticker: item.ticker)
                    } label: {
                        StockTickerView(stock: item)
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            deleteItem(item: item)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .searchable(text: $viewModel.searchQuery, placement: .toolbar)
            .onSubmit(of: .search) {
                Task {
                    await viewModel.search()
                }
            }
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
        } detail: {
            Text("Select a stock")
        }
    }

    private func addItem() {
        withAnimation {
            modelContext.insert(StockItem(name: "Apple Inc", ticker: "AAPL", price: 178.0))
        }
    }
    
    private func deleteItem(item: StockItem) {
        if let index = items.firstIndex(where: { $0.ticker == item.ticker }) {
            withAnimation {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    MainView()
        .modelContainer(for: StockItem.self, inMemory: true)
}
