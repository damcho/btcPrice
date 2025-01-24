//
//  BinanceBTCLoaderMapperTests.swift
//  BTCLoaderTests
//
//  Created by Damian Modernell on 24/1/25.
//

import XCTest
@testable import BTCLoader

final class BinanceBTCLoaderMapperTests: XCTestCase {
    
    func test_throws_on_non_200_http_response() throws {
        XCTAssertThrowsError(
            try BinanceBTCLoaderMapper.map(
                http: (non200HTTPResponse, anyData)
            )
        )
    }
    
    func test_throws_on_200_response_and_empty_data() throws {
        let emptyData = Data()
        XCTAssertThrowsError(
            try BinanceBTCLoaderMapper.map(
                http: (validHTTPResponse, emptyData)
            )
        )
    }
    
    func test_maps_btc_price_successfully() throws {
        let expectedBTCPrice = anyBTCPrice
        
        let decodedBTCprice = try BinanceBTCLoaderMapper.map(
            http: (validHTTPResponse, expectedBTCPrice.encoded)
        )
        
        XCTAssertEqual(decodedBTCprice, expectedBTCPrice.decoded)
    }
}

private extension BinanceBTCLoaderMapperTests {
    var anyBTCPrice: (decoded: BTCPrice, encoded: Data) {
        (
            BTCPrice(amount: 104593.190, currency: .USD),
            #"{"symbol":"BTCUSDT","price":"104593.19000000"}"#.data(using: .utf8)!
        )
    }
}

var non200HTTPResponse: HTTPURLResponse {
    HTTPURLResponse(
        url: anyURL,
        statusCode: 404,
        httpVersion: nil,
        headerFields: nil
    )!
}

var validHTTPResponse: HTTPURLResponse {
    HTTPURLResponse(
        url: anyURL,
        statusCode: 200,
        httpVersion: nil,
        headerFields: nil
    )!
}
