//
//  BTCPriceErrorView.swift
//  BTCPriceLoaderApp
//
//  Created by Damian Modernell on 25/1/25.
//

import SwiftUI

struct BTCPriceErrorView: View {
    @StateObject var errorViewModel: BTCPriceErrorViewModel
    var body: some View {
        Text(errorViewModel.errorLabel)
            .font(.system(.subheadline))
            .multilineTextAlignment(.center)
    }
}

#Preview {
    BTCPriceErrorView(
        errorViewModel: .init(dateFormatter: .init())
    )
}

#Preview {
    let viewModel = BTCPriceErrorViewModel(
        dateFormatter: BTCAppComposer.errorViewModelDateFormatter
    )
    viewModel.displayBTCLoadError()
    return BTCPriceErrorView(
        errorViewModel: viewModel
    )
}

#Preview {
    let viewModel = BTCPriceErrorViewModel(
        dateFormatter: BTCAppComposer.errorViewModelDateFormatter
    )
    viewModel.hideBTCLoadError(at: .now)
    viewModel.displayBTCLoadError()
    return BTCPriceErrorView(
        errorViewModel: viewModel
    )
}
