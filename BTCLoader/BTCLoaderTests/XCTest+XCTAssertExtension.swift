//
//  XCTest+XCTAssertExtension.swift
//  BTCLoaderTests
//
//  Created by Damian Modernell on 23/1/25.
//
import XCTest

extension XCTest {
    func AsyncXCTAssertThrowsError(
        _ expression: @autoclosure () async throws -> some Sendable,
        _ message: @autoclosure () -> String = "This call should throw an error.",
        file: StaticString = #filePath,
        line: UInt = #line,
        _ errorHandler: (_ error: Error) -> Void = { _ in }
    ) async {
        do {
            _ = try await expression()
            XCTFail(message(), file: file, line: line)
        } catch {
            errorHandler(error)
        }
    }
}
