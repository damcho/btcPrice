//
//  BTCPriceLoaderAcceptanceTests.swift
//  BTCPriceLoaderAppTests
//
//  Created by Damian Modernell on 26/1/25.
//

import XCTest
@testable import BTCPriceLoaderApp
import BTCLoader

final class BTCPriceLoaderAcceptanceTests: XCTestCase {

    func test_displays_error_view_with_no_timestamp_on_no_network_connection() async {
        let (sut, _, btcPriceErrorView, _) = makeSUT(
            btcloadableStub: .failure(.connectivity)
        )
        
        await sut.load().value
        
        XCTAssertEqual(btcPriceErrorView.errorLabel, "Failed to load BTC price")
    }
    
    func test_displays_btc_price_on_successful_remote_load() async {
        let (sut, btcPriceViewModel, _, _) = makeSUT(
            btcloadableStub: .success(anyBTCPrice)
        )
        
        await sut.load().value

        XCTAssertEqual(
            btcPriceViewModel.btcPrice,
            BTCPriceViewRepresentation(price: "\(anyBTCPrice.amount)", color: .black)
        )
    }
    
    
    func test_empty_error_label_on_successful_btc_price_load() async {
        let (sut, _, btcPriceErrorView, _) = makeSUT(
            btcloadableStub: .success(anyBTCPrice)
        )
        XCTAssertTrue(btcPriceErrorView.errorLabel.isEmpty)

        await sut.load().value

        XCTAssertTrue(btcPriceErrorView.errorLabel.isEmpty)
    }
    
    func test_empty_error_label_after_showing_error_and_successful_btc_price_load() async {
        let (sut, _, btcPriceErrorView, btcLoadableStub) = makeSUT(
            btcloadableStub: .failure(.connectivity)
        )
        await sut.load().value
        btcLoadableStub.stub = .success(anyBTCPrice)

        await sut.load().value

        XCTAssertTrue(btcPriceErrorView.errorLabel.isEmpty)
    }
    
    func test_dispatches_on_main_thread_on_successful_btc_price_load() async {
        let (sut, _, btcPriceErrorViewModelTestDouble, _) = makeSUT(
            btcloadableStub: .success(anyBTCPrice)
        )
        
        let task = sut.load()
        await task.value
        
        XCTAssertTrue(btcPriceErrorViewModelTestDouble.isMainThread)
    }
    
    func test_dispatches_on_main_thread_on_btc_price_load_failure() async {
        let (sut, _, btcPriceErrorViewModelTestDouble, _) = makeSUT(
            btcloadableStub: .failure(.connectivity)
        )
        
        let task = sut.load()
        await task.value
        
        XCTAssertTrue(btcPriceErrorViewModelTestDouble.isMainThread)
    }
}

extension BTCPriceLoaderAcceptanceTests {
    private func makeSUT(
        btcloadableStub: Result<BTCPrice, RemoteBTCPriceLoaderError>
    ) -> (BTCLoaderAdapter, BTCPriceViewModel, BTCPriceErrorViewModelTestDouble, BTCPriceLoadableStub) {
        let btcPriceViewModel = BTCPriceViewModel()
        let btcPriceErrorViewModel = BTCPriceErrorViewModelTestDouble()
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

final class BTCPriceErrorViewModelTestDouble: BTCPriceErrorViewModel {
    var isMainThread = false
    override func displayBTCLoadError() {
        super.displayBTCLoadError()
        isMainThread = Thread.isMainThread
    }
    
    override func hideBTCLoadError(at date: Date) {
        super.hideBTCLoadError(at: date)
        isMainThread = Thread.isMainThread
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
