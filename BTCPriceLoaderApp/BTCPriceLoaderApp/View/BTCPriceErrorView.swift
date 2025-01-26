//
//  BTCPriceErrorView.swift
//  BTCPriceLoaderApp
//
//  Created by Damian Modernell on 25/1/25.
//

import SwiftUI

struct BTCPriceErrorView: View {
    var body: some View {
        Text("Failed to update value. Displaying last updated value from Jan 24th, 21:07")
            .font(.system(.subheadline))
            .multilineTextAlignment(.center)
    }
}

#Preview {
    BTCPriceErrorView()
}
