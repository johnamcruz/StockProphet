//
//  StockTickerView.swift
//  StockProphet
//
//  Created by John M Cruz on 10/15/23.
//

import SwiftUI

struct StockTickerView: View {
    let company: Company
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text(company.ticker)
                    .font(.headline)
                Text(company.name)
                    .font(.caption)
            }
            Spacer()
            RoundedRectangle(cornerRadius: 4.0)
                .fill(Color.forestGreen)
                .frame(width: 80, height: 30)
                .overlay {
                    Text(company.price.formatted(.currency(code: "USD")))
                        .font(.subheadline)
                }
        }
        .padding()
        .frame(height: 35)
    }
}

#Preview {
    StockTickerView(company: Company.mock)
}
