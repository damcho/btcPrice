//
//  ContentView.swift
//  BTCPriceLoaderApp
//
//  Created by Damian Modernell on 25/1/25.
//

import SwiftUI

struct BTCPriceView: View {
    @State var btcPrice: String = ""
    var body: some View {
        VStack {
            Text(btcPrice)
                .font(.system(.largeTitle))
        }
        .padding()
    }
}

#Preview {
    BTCPriceView(
        btcPrice: "BTC/USD: $104,153.2"
    )
}
