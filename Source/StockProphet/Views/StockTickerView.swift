//
//  StockTickerView.swift
//  StockProphet
//
//  Created by John M Cruz on 10/15/23.
//

import SwiftUI

struct StockTickerView: View {
    let stock: StockItem
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text(stock.ticker)
                    .font(.headline)
                Text(stock.name)
                    .font(.caption)
            }
            Spacer()
            RoundedRectangle(cornerRadius: 4.0)
                .fill(Color.green)
                .frame(width: 80, height: 30)
                .overlay {
                    Text(stock.price.formatted(.currency(code: "USD")))
                        .font(.subheadline)
                }
        }
        .padding()
        .frame(height: 35)
    }
}

#Preview {
    StockTickerView(stock: StockItem.mock)
}
