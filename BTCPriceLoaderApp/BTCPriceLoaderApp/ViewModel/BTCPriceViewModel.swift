//
//  BTCPriceViewModel.swift
//  BTCPriceLoaderApp
//
//  Created by Damian Modernell on 26/1/25.
//
import Foundation
import SwiftUI

struct BTCPriceViewRepresentation: Equatable {
    let price: String
    let color: Color
}

final class BTCPriceViewModel: ObservableObject {
    @Published var btcPriceLabel: String = ""
    var btcPrice: BTCPriceViewRepresentation = .init(price: "", color: .black) {
        didSet {
            btcPriceLabel = "BTC/USD: \(btcPrice.price)"
        }
    }
}
