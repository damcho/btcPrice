//
//  BTCPriceErrorViewModelTests.swift
//  BTCPriceLoaderAppTests
//
//  Created by Damian Modernell on 26/1/25.
//

import XCTest
import Foundation

final class BTCPriceErrorViewModel {
    private(set)var errorLabel: String = ""
    var lastUpdatedBTCPriceDate: Date?
    private let dateformatter: DateFormatter
    
    init(dateFormatter: DateFormatter = DateFormatter()) {
        self.dateformatter = dateFormatter
    }
    
    func displayBTCLoadError() {
        if let alastUpdatedBTCPriceDate = lastUpdatedBTCPriceDate {
            errorLabel = "Failed to update value. Displaying last updated value from \(dateformatter.string(from: alastUpdatedBTCPriceDate))"
        } else {
            errorLabel = "Failed to load BTC price"
        }
    }
    
    func hideBTCLoadError(at date: Date) {
        lastUpdatedBTCPriceDate = date
        errorLabel = ""
    }
}

final class BTCPriceErrorViewModelTests: XCTestCase {
    
    func test_displays_empty_message_on_initialization() {
        let btcErrorViewModel = makeSUT()

        XCTAssertTrue(btcErrorViewModel.errorLabel.isEmpty)
    }
    
    func test_displays_error_with_no_btc_price_on_no_btc_price_available() {
        let btcErrorViewModel = makeSUT()
        
        btcErrorViewModel.displayBTCLoadError()
        
        XCTAssertEqual(btcErrorViewModel.errorLabel, "Failed to load BTC price")
    }
    
    func test_displays_error_with_btc_price_on_btc_price_available() {
        let btcErrorViewModel = makeSUT()
        btcErrorViewModel.hideBTCLoadError(at: randomDate.date)
        
        btcErrorViewModel.displayBTCLoadError()
        
        XCTAssertEqual(btcErrorViewModel.errorLabel, "Failed to update value. Displaying last updated value from \(randomDate.stringRepresentation)")
    }
    
    func test_empty_error_on_hide_error_called() {
        let btcErrorViewModel = makeSUT()
        btcErrorViewModel.hideBTCLoadError(at: randomDate.date)

        XCTAssertEqual(btcErrorViewModel.errorLabel, "")
    }

    func test_updates_last_btc_loaded_timestamp_on_multiple_error_calls() {
        let btcErrorViewModel = makeSUT()
        btcErrorViewModel.hideBTCLoadError(at: randomDate.date)
        btcErrorViewModel.displayBTCLoadError()
        XCTAssertEqual(btcErrorViewModel.errorLabel, "Failed to update value. Displaying last updated value from \(randomDate.stringRepresentation)")
        
        btcErrorViewModel.hideBTCLoadError(at: randomDatePlusOneSecond.date)
        btcErrorViewModel.displayBTCLoadError()
        
        XCTAssertEqual(btcErrorViewModel.errorLabel, "Failed to update value. Displaying last updated value from \(randomDatePlusOneSecond.stringRepresentation)")
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
