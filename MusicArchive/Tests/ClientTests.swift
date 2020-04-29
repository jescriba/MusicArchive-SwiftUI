// Copyright (c) 2020 Joshua Escribano-Fontanet

@testable import MusicArchiveFramework
import XCTest

struct TestError: Error {}

final class ClientTests: XCTestCase {
    private var client: Client<Song>!
    override func setUp() {
        client = .init()
    }

    func testDecodeSuccess() {
        let e = expectation(description: "Succeeds")
        let song = try! JSONEncoder().encode(Song.mock)
        client.data = { _, completion in completion(.success(song)) }
        client.fetch { result in
            XCTAssertTrue(result.isFailure)
            e.fulfill()
        }
        waitForExpectations(timeout: 0.01, handler: nil)
    }

    func testDecodeFailure() {
        let e = expectation(description: "Succeeds on data, fails on decode")
        client.data = { _, completion in completion(.success("foo".data(using: .utf8)!)) }
        client.fetch { result in
            XCTAssertTrue(result.isFailure)
            e.fulfill()
        }
        waitForExpectations(timeout: 0.01, handler: nil)
    }

    func testFailure() {
        let e = expectation(description: "Fails on error")
        client.data = { _, completion in completion(.failure(TestError())) }
        client.fetch { result in
            XCTAssertTrue(result.isFailure)
            e.fulfill()
        }
        waitForExpectations(timeout: 0.01, handler: nil)
    }
}

#if INTEGRATION_TESTS

final class ClientIntegrationTests: XCTestCase {
    private var client: Client<Song>!
    override func setUp() {
        client = .init()
    }

    func testDecodeSuccess() {
        let e = expectation(description: "Succeeds decoding live data")
        client.fetch { result in
            XCTAssertTrue(result.isSuccess)
            e.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
}

#endif

extension Song {
    static let mock = Self(id: .init(rawValue: 0),
                           createdAt: .init(),
                           name: "Test",
                           description: nil,
                           url: nil,
                           recordedAt: nil,
                           artists: [])
}
