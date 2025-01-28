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
        Text(btcPriceViewModel.btcPriceLabel)
            .font(.system(.largeTitle))
            .foregroundStyle(
                btcPriceViewModel.btcPrice.color
        )
    }
}

#Preview {
    let btcPriceViewModel = BTCPriceViewModel()
    btcPriceViewModel.btcPrice = .init(
        price: 104345.3, color: .red
    )
    return BTCPriceView(
        btcPriceViewModel: btcPriceViewModel
    )
}

#Preview {
    let btcPriceViewModel = BTCPriceViewModel()
    btcPriceViewModel.btcPrice = .init(
        price: 104345.5, color: .black
    )
    return BTCPriceView(
        btcPriceViewModel: btcPriceViewModel
    )
}

#Preview {
    let btcPriceViewModel = BTCPriceViewModel()
    btcPriceViewModel.btcPrice = .init(
        price: 104345.5, color: .green
    )
    return BTCPriceView(
        btcPriceViewModel: btcPriceViewModel
    )
}
