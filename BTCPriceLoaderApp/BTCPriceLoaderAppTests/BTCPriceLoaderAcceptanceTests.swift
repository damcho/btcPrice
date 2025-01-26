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
        btcPriceErrorViewModel.displayBTCLoadError()
    }
}

final class BTCPriceLoaderAcceptanceTests: XCTestCase {

    func test_displays_error_view_with_no_timestamp_on_no_network_connection() async {
        let (sut, _, btcPriceErrorView) = makeSUT(
            httpClientStub: .failure(.timeout)
        )
        
        await sut.load()
        
        XCTAssertEqual(btcPriceErrorView.errorLabel, "Failed to load BTC price")
    }
}

extension BTCPriceLoaderAcceptanceTests {
    private func makeSUT(
        httpClientStub: Result<(HTTPURLResponse, Data), HTTPClientError>
    ) -> (BTCLoaderAdapter, BTCPriceViewModel, BTCPriceErrorViewModel) {
        let btcPriceViewModel = BTCPriceViewModel()
        let btcPriceErrorViewModel = BTCPriceErrorViewModel()
        let loaderAdapter = BTCLoaderAdapter(
            loader: BTCPriceLoaderUtility.makeLoader(
                with: HTTPClientStub(
                    stub: httpClientStub
                )
            ),
            btcPriceViewModel: btcPriceViewModel,
            btcPriceErrorViewModel: btcPriceErrorViewModel
        )
        return (loaderAdapter, btcPriceViewModel, btcPriceErrorViewModel)
    }
}

struct HTTPClientStub: HTTPClient {
    let stub: Result<(HTTPURLResponse, Data), HTTPClientError>
    func load(url: URL) async throws(BTCLoader.HTTPClientError) -> (HTTPURLResponse, Data) {
        try stub.get()
    }
}
