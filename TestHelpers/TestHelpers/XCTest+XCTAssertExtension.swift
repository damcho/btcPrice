//
//  XCTest+XCTAssertExtension.swift
//  TestHelpers
//
//  Created by Damian Modernell on 7/2/25.
//

import XCTest

public extension XCTestCase {
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
    
    @MainActor
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(
                instance,
                "Instance should have been deallocated. Potential memory leak.",
                file: file,
                line: line
            )
        }
    }
}
