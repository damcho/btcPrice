//
//  BTCPriceLoaderAcceptanceTests.swift
//  BTCPriceLoaderAppTests
//
//  Created by Damian Modernell on 26/1/25.
//

import XCTest
@testable import BTCPriceLoaderApp
import BTCLoader

struct BTCLoaderAdapter {
    let loader: BTCPriceLoadable
    let btcPriceViewModel: BTCPriceViewModel
    let btcPriceErrorViewModel: BTCPriceErrorViewModel
    
    func load() async {
        do {
            let btcPrice = try await loader.loadBTCPrice()
            btcPriceViewModel.btcPrice = BTCPriceViewRepresentation(
                price: "$\(btcPrice.amount)",
                color: .black
            )
        } catch {
            btcPriceErrorViewModel.displayBTCLoadError()
        }
    }
}

final class BTCPriceLoaderAcceptanceTests: XCTestCase {

    func test_displays_error_view_with_no_timestamp_on_no_network_connection() async {
        let (sut, _, btcPriceErrorView, _) = makeSUT(
            btcloadableStub: .failure(.connectivity)
        )
        
        await sut.load()
        
        XCTAssertEqual(btcPriceErrorView.errorLabel, "Failed to load BTC price")
    }
    
    func test_displays_btc_price_on_successful_remote_load() async {
        let (sut, btcPriceViewModel, _, _) = makeSUT(
            btcloadableStub: .success(anyBTCPrice)
        )
        
        await sut.load()
        
        XCTAssertEqual(
            btcPriceViewModel.btcPrice,
            BTCPriceViewRepresentation(price: "$\(anyBTCPrice.amount)", color: .black)
        )
    }
}

extension BTCPriceLoaderAcceptanceTests {
    private func makeSUT(
        btcloadableStub: Result<BTCPrice, RemoteBTCPriceLoaderError>
    ) -> (BTCLoaderAdapter, BTCPriceViewModel, BTCPriceErrorViewModel, BTCPriceLoadableStub) {
        let btcPriceViewModel = BTCPriceViewModel()
        let btcPriceErrorViewModel = BTCPriceErrorViewModel()
        let btcLoadableStub = BTCPriceLoadableStub(
            stub: btcloadableStub
        )
        let loaderAdapter = BTCLoaderAdapter(
            loader: btcLoadableStub,
            btcPriceViewModel: btcPriceViewModel,
            btcPriceErrorViewModel: btcPriceErrorViewModel
        )
        return (loaderAdapter, btcPriceViewModel, btcPriceErrorViewModel, btcLoadableStub)
    }
}

class BTCPriceLoadableStub: BTCPriceLoadable {
    var stub: Result<BTCPrice, RemoteBTCPriceLoaderError>
    init(stub: Result<BTCPrice, RemoteBTCPriceLoaderError>) {
        self.stub = stub
    }
    func loadBTCPrice() async throws(BTCLoader.RemoteBTCPriceLoaderError) -> BTCLoader.BTCPrice {
        try stub.get()
    }
}

var anyBTCPrice: BTCPrice {
    BTCPrice(amount: 10, currency: .USD)
}
