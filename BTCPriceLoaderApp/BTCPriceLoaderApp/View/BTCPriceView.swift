//
//  ContentView.swift
//  BTCPriceLoaderApp
//
//  Created by Damian Modernell on 25/1/25.
//

import SwiftUI

struct BTCPriceView: View {
    @StateObject var btcPriceViewModel: BTCPriceViewModel
    var body: some View {
        VStack {
            Text(btcPriceViewModel.btcPriceLabel)
                .font(.system(.largeTitle))
                .foregroundStyle(
                    btcPriceViewModel.btcPrice.color
                )
        }
        .padding()
    }
}

#Preview {
    BTCPriceView(
        btcPriceViewModel: BTCPriceViewModel()
    )
}

#Preview {
    let btcPriceViewModel = BTCPriceViewModel()
    btcPriceViewModel.btcPrice = .init(
        price: "104,345.5", color: .red
    )
    return BTCPriceView(
        btcPriceViewModel: btcPriceViewModel
    )
}

#Preview {
    let btcPriceViewModel = BTCPriceViewModel()
    btcPriceViewModel.btcPrice = .init(
        price: "104,345.5", color: .green
    )
    return BTCPriceView(
        btcPriceViewModel: btcPriceViewModel
    )
}
