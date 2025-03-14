//
//  BTCPriceErrorViewModelTests.swift
//  BTCPriceLoaderAppTests
//
//  Created by Damian Modernell on 26/1/25.
//

@testable import BTCPriceLoaderApp
import XCTest

final class BTCPriceErrorViewModelTests: XCTestCase {
    func test_displays_empty_message_on_initialization() {
        let btcErrorViewModel = makeSUT()

        XCTAssertTrue(btcErrorViewModel.errorLabel.isEmpty)
    }

    func test_displays_error_with_no_btc_price_on_no_btc_price_available() {
        let btcErrorViewModel = makeSUT()

        btcErrorViewModel.displayBTCLoadError()

        XCTAssertEqual(btcErrorViewModel.errorLabel, BTCPriceErrorFormat.noTimesamp.value)
    }

    func test_displays_error_with_btc_price_on_btc_update_timestamp_available() {
        let btcErrorViewModel = makeSUT()

        btcErrorViewModel.displayBTCLoadError(for: randomDate.date)

        XCTAssertEqual(
            btcErrorViewModel.errorLabel,
            BTCPriceErrorFormat.timestamp(randomDate.stringRepresentation).value
        )
    }

    func test_empty_error_on_hide_error_called() {
        let btcErrorViewModel = makeSUT()
        btcErrorViewModel.hideBTCLoadError()

        XCTAssertEqual(btcErrorViewModel.errorLabel, "")
    }

    func test_updates_last_btc_loaded_timestamp_on_multiple_error_calls() {
        let btcErrorViewModel = makeSUT()
        btcErrorViewModel.displayBTCLoadError(for: randomDate.date)
        XCTAssertEqual(
            btcErrorViewModel.errorLabel,
            BTCPriceErrorFormat.timestamp(randomDate.stringRepresentation).value
        )

        btcErrorViewModel.hideBTCLoadError()
        btcErrorViewModel.displayBTCLoadError(for: randomDatePlusOneSecond.date)

        XCTAssertEqual(
            btcErrorViewModel.errorLabel,
            BTCPriceErrorFormat.timestamp(randomDate.stringRepresentation).value
        )
    }
}

extension BTCPriceErrorViewModelTests {
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter
    }

    func makeSUT() -> BTCPriceErrorViewModel {
        BTCPriceErrorViewModel(
            dateFormatter: dateFormatter
        )
    }

    var randomDate: (date: Date, stringRepresentation: String) {
        let aDate = dateFormatter.date(from: "2016/10/08 22:31")!
        return (
            aDate,
            dateFormatter.string(from: aDate)
        )
    }

    var randomDatePlusOneSecond: (date: Date, stringRepresentation: String) {
        let randomDate = randomDate.date.addingTimeInterval(1)
        return (
            randomDate,
            dateFormatter.string(from: randomDate)
        )
    }
}
