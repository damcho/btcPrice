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
        let result: ResultList
        
        func toBTCPrice() throws -> RemoteBTCPrice {
            guard let firstIndexPrice = result.list.first?.indexPrice,
            let aDoublePrice = Double(firstIndexPrice) else {
                throw RemoteBTCPriceLoaderError.decoding
            }
            
            return RemoteBTCPrice(amount: aDoublePrice, currency: .USD)
        }
    }
    
    struct ResultList: Decodable {
        let list: [BTCPriceInfo]
    }
    
    struct BTCPriceInfo: Decodable {
        let indexPrice: String
    }
    
    static func map(http: (response: HTTPURLResponse, data: Data)) throws -> RemoteBTCPrice {
        guard http.response.statusCode == 200 else {
            throw RemoteBTCPriceLoaderError.connectivity
        }
        let bybitBTCPrice = try JSONDecoder().decode(
            BybitBTCPrice.self,
            from: http.data
        )
        return try bybitBTCPrice.toBTCPrice()
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
