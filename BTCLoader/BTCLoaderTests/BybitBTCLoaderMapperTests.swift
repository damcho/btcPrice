//
//  BybitBTCLoaderMapperTests.swift
//  BTCLoaderTests
//
//  Created by Damian Modernell on 6/2/25.
//

import XCTest
@testable import BTCLoader

struct BybitBTCLoaderMapper {
    struct BybitBTCPrice: Decodable {
        
    }
    static func map(http: (response: HTTPURLResponse, data: Data)) throws -> RemoteBTCPrice {
        guard http.response.statusCode == 200 else {
            throw RemoteBTCPriceLoaderError.connectivity
        }
        let bybitBTCPrice = try JSONDecoder().decode(
            BybitBTCPrice.self,
            from: http.data
        )
        return .init(amount: 10, currency: .USD)
    }
}

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
    
    func test_throws_on_decoding_error() throws {
        
    }
}
