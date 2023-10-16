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
                        ChartView(stocks: viewModel.service.getStock(ticker: item.ticker))
                    } label: {
                        StockTickerView(stock: item)
                    }
                }
                .onDelete(perform: deleteItems)
            }
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
        .task {
            await viewModel.load()
        }
        .overlay {
            if viewModel.isLoading {
                Rectangle()
                    .background(.clear.opacity(0.8))
                    .overlay {
                        VStack(alignment: .center) {
                            ProgressView()
                                .progressViewStyle(.circular)
                        }
                    }
            }
        }
    }

    private func addItem() {
        withAnimation {
            modelContext.insert(StockItem(name: "Apple Inc", ticker: "APPL", price: 178.0))
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    MainView()
        .modelContainer(for: StockItem.self, inMemory: true)
}
