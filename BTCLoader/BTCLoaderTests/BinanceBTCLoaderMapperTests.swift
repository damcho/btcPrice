//
//  BinanceBTCLoaderMapperTests.swift
//  BTCLoaderTests
//
//  Created by Damian Modernell on 24/1/25.
//

import XCTest
@testable import BTCLoader

enum BinanceBTCLoaderMapper {
    static func map(_ response: HTTPURLResponse, _ data: Data) throws -> BTCPrice {
        throw RemoteBTCPriceLoaderError.connectivity
    }
}

final class BinanceBTCLoaderMapperTests: XCTestCase {
    
    func test_throws_on_non_200_http_response() throws {
        XCTAssertThrowsError(
            try BinanceBTCLoaderMapper.map(non200HTTPResponse, anyData)
        )
    }
    
    func test_throws_on_200_response_and_empty_data() throws {
        let emptyData = Data()
        XCTAssertThrowsError(
            try BinanceBTCLoaderMapper.map(validHTTPResponse, emptyData)
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
