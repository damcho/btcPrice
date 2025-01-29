//
//  BTCUtilityView.swift
//  BTCPriceLoaderApp
//
//  Created by Damian Modernell on 28/1/25.
//

import SwiftUI

struct BTCUtilityView: View {
    let btcPriceView: BTCPriceView
    let btcPriceErrorView: BTCPriceErrorView
    
    var body: some View {
        btcPriceErrorView
        Spacer()
        btcPriceView
        Spacer()
    }
}

#Preview {
    let btcPriceViewModel = BTCPriceViewModel()
    btcPriceViewModel.btcPrice = .init(
        price: 104345.5, color: .red
    )
    let errorViewModel = BTCPriceErrorViewModel(
        dateFormatter: BTCAppComposer.errorViewModelDateFormatter
    )
    errorViewModel.displayBTCLoadError(for: .now)
    return BTCUtilityView(
        btcPriceView: BTCPriceView(
            btcPriceViewModel: btcPriceViewModel
        ),
        btcPriceErrorView: BTCPriceErrorView(
            errorViewModel: errorViewModel
        )
    )
}

#Preview {
    let btcPriceViewModel = BTCPriceViewModel()
    let errorViewModel = BTCPriceErrorViewModel(
        dateFormatter: BTCAppComposer.errorViewModelDateFormatter
    )
    errorViewModel.displayBTCLoadError(for: nil)
    return BTCUtilityView(
        btcPriceView: BTCPriceView(
            btcPriceViewModel: btcPriceViewModel
        ),
        btcPriceErrorView: BTCPriceErrorView(
            errorViewModel: errorViewModel
        )
    )
}

#Preview {
    let btcPriceViewModel = BTCPriceViewModel()
    btcPriceViewModel.btcPrice = .init(
        price: 104345.5, color: .green
    )
    return BTCUtilityView(
        btcPriceView: BTCPriceView(
            btcPriceViewModel: btcPriceViewModel
        ),
        btcPriceErrorView: BTCPriceErrorView(
            errorViewModel: BTCPriceErrorViewModel(
                dateFormatter: BTCAppComposer.errorViewModelDateFormatter
            )
        )
    )
}
