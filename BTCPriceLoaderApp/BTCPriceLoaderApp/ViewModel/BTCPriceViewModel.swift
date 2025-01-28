//
//  BTCPriceViewModel.swift
//  BTCPriceLoaderApp
//
//  Created by Damian Modernell on 26/1/25.
//
import Foundation

final class BTCPriceViewModel: ObservableObject {
    @Published var btcPriceLabel: String = ""
    var btcPrice: BTCPriceViewRepresentation = .init(price: 0, color: .black) {
        didSet {
            btcPriceLabel = "BTC/USD: \(btcPrice.stringPriceRepresentation)"
        }
    }
}
