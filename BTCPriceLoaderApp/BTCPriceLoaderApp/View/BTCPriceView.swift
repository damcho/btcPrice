//
//  ContentView.swift
//  BTCPriceLoaderApp
//
//  Created by Damian Modernell on 25/1/25.
//

import SwiftUI

struct BTCPriceView: View {
    @StateObject var btcPriceViewModel: BTCPriceViewModel
    let errorView: BTCPriceErrorView
    var body: some View {
        VStack {
            errorView
            Spacer()
            Text(btcPriceViewModel.btcPriceLabel)
                .font(.system(.largeTitle))
                .foregroundStyle(
                    btcPriceViewModel.btcPrice.color
                )
            Spacer()
        }
        .padding()
    }
}

#Preview {
    let btcPriceViewModel = BTCPriceViewModel()
    btcPriceViewModel.btcPrice = .init(
        price: "104,345.5", color: .red
    )
    let errorViewModel = BTCPriceErrorViewModel()
    errorViewModel.displayBTCLoadError()
    return BTCPriceView(
        btcPriceViewModel: btcPriceViewModel,
        errorView: BTCPriceErrorView(
            errorViewModel: errorViewModel
        )
    )
}

#Preview {
    let btcPriceViewModel = BTCPriceViewModel()
    btcPriceViewModel.btcPrice = .init(
        price: "104,345.5", color: .red
    )
    return BTCPriceView(
        btcPriceViewModel: btcPriceViewModel,
        errorView: BTCPriceErrorView(
            errorViewModel: BTCPriceErrorViewModel()
        )
    )
}

#Preview {
    let btcPriceViewModel = BTCPriceViewModel()
    btcPriceViewModel.btcPrice = .init(
        price: "104,345.5", color: .green
    )
    return BTCPriceView(
        btcPriceViewModel: btcPriceViewModel,
        errorView: BTCPriceErrorView(
            errorViewModel: BTCPriceErrorViewModel()
        )
    )
}
