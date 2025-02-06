//
//  BinanceBTCLoaderMapperTests.swift
//  BTCLoaderTests
//
//  Created by Damian Modernell on 24/1/25.
//

import XCTest
@testable import BTCLoader

protocol BTCMapperSpecs {
    func test_throws_on_non_200_http_response() throws
    func test_throws_on_200_response_and_empty_data() throws
    func test_maps_btc_price_successfully() throws
    func test_throws_on_decoding_error() throws
}

final class BinanceBTCLoaderMapperTests: XCTestCase, BTCMapperSpecs {
    
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
        let expectedBTCPrice = anyBinanceBTCPrice
        
        let decodedBTCprice = try BinanceBTCLoaderMapper.map(
            http: (validHTTPResponse, expectedBTCPrice.encoded)
        )
        
        XCTAssertEqual(decodedBTCprice, expectedBTCPrice.decoded)
    }
    
    func test_throws_on_decoding_error() throws {
        XCTAssertThrowsError(
            try BinanceBTCLoaderMapper.map(
                http: (validHTTPResponse, anyInvalidEncodedBTCPrice.encoded)
            )
        )
    }
}
