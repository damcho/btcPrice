//
//  Helpers.swift
//  TestHelpers
//
//  Created by Damian Modernell on 7/2/25.
//

import Foundation

public var anyURL: URL {
    URL(string: "http://any-url.com")!
}

public var anyNSError: NSError {
    NSError(domain: "any error", code: 0)
}

public var anyData: Data {
    Data("any data".utf8)
}
