//
//  BTCPriceViewRepresentation.swift
//  BTCPriceLoaderApp
//
//  Created by Damian Modernell on 28/1/25.
//

import Foundation
import SwiftUI
import BTCLoader

struct BTCPriceViewRepresentation: Equatable {
    private let price: Double
    private let currency: Currency
    let color: Color
    
    var stringPriceRepresentation: String {
        price.formatted(.currency(code: currency.code).presentation(.narrow))
    }
    
    init(price: Double, currency: Currency = .USD, color: Color) {
        self.price = price
        self.color = color
        self.currency = currency
    }
}
