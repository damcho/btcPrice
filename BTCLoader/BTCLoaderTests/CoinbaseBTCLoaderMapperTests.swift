//
//  CoinbaseBTCLoaderMapperTests.swift
//  BTCLoaderTests
//
//  Created by Damian Modernell on 24/1/25.
//

import XCTest
@testable import BTCLoader

final class CoinbaseBTCLoaderMapperTests: XCTestCase {

    func test_throws_on_non_200_http_response() throws {
        XCTAssertThrowsError(
            try CoinbaseBTCLoaderMapper.map(http: (non200HTTPResponse, anyData))
        )
    }
    
    func test_throws_on_200_response_and_empty_data() throws {
        let emptyData = Data()
        XCTAssertThrowsError(
            try CoinbaseBTCLoaderMapper.map(http: (validHTTPResponse, emptyData))
        )
    }
    
    func test_maps_btc_price_successfully() throws {
        let expectedBTCPrice = anyBTCPrice
        
        let decodedBTCprice = try CoinbaseBTCLoaderMapper.map(
            http: (validHTTPResponse, expectedBTCPrice.encoded)
        )
        
        XCTAssertEqual(decodedBTCprice, expectedBTCPrice.decoded)
    }
}

private extension CoinbaseBTCLoaderMapperTests {
    var anyBTCPrice: (decoded: RemoteBTCPrice, encoded: Data) {
        (
            RemoteBTCPrice(amount: 103457.5, currency: .USD),
            #"{"RAW":{"MARKET":"CUSTOMAGG","FROMSYMBOL":"BTC","TOSYMBOL":"USD","FLAGS":0,"PRICE":103457.51,"LASTUPDATE":1737685911,"LASTVOLUME":0.00000183,"LASTVOLUMETO":0.1893272433,"LASTTRADEID":"766587058","VOLUME24HOUR":24311.60952878,"VOLUME24HOURTO":2535660127.21734,"OPEN24HOUR":102574.45,"HIGH24HOUR":106870.87,"LOW24HOUR":101200.01,"LASTMARKET":"Coinbase","TOPTIERVOLUME24HOUR":24311.60952878,"TOPTIERVOLUME24HOURTO":2535660127.21734,"CHANGE24HOUR":883.059999999998,"CHANGEPCT24HOUR":0.860896646289595,"CHANGEDAY":0,"CHANGEPCTDAY":0,"CHANGEHOUR":0,"CHANGEPCTHOUR":0},"DISPLAY":{"FROMSYMBOL":"Ƀ","TOSYMBOL":"$","MARKET":"CUSTOMAGG","PRICE":"$ 103,457.5","LASTUPDATE":"Just now","LASTVOLUME":"Ƀ 0.00000183","LASTVOLUMETO":"$ 0.1893","LASTTRADEID":"766587058","VOLUME24HOUR":"Ƀ 24,311.6","VOLUME24HOURTO":"$ 2,535,660,127.2","OPEN24HOUR":"$ 102,574.5","HIGH24HOUR":"$ 106,870.9","LOW24HOUR":"$ 101,200.0","LASTMARKET":"Coinbase","TOPTIERVOLUME24HOUR":"Ƀ 24,311.6","TOPTIERVOLUME24HOURTO":"$ 2,535,660,127.2","CHANGE24HOUR":"$ 883.06","CHANGEPCT24HOUR":"0.86","CHANGEDAY":"$ 0","CHANGEPCTDAY":"0","CHANGEHOUR":"$ 0","CHANGEPCTHOUR":"0"}}"#.data(using: .utf8)!
        )
    }
}
