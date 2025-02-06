//
//  BybitBTCLoaderMapperTests.swift
//  BTCLoaderTests
//
//  Created by Damian Modernell on 6/2/25.
//

import XCTest
@testable import BTCLoader

final class BybitBTCLoaderMapperTests: XCTestCase, BTCMapperSpecs {
    func test_throws_on_non_200_http_response() throws {
        XCTAssertThrowsError(
            try BybitBTCLoaderMapper.map(
                http: (non200HTTPResponse, anyData)
            )
        )
    }
    
    func test_throws_on_200_response_and_empty_data() throws {
        let emptyData = Data()
        XCTAssertThrowsError(
            try BybitBTCLoaderMapper.map(
                http: (validHTTPResponse, emptyData)
            )
        )
    }
    
    func test_maps_btc_price_successfully() throws {
        let expectedBTCPrice = anyBybitBTCPrice
        
        let decodedBTCprice = try BybitBTCLoaderMapper.map(
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
