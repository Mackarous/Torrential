//
//  TorrentialTests.swift
//  TorrentialTests
//
//  Created by Andrew Mackarous on 2018-10-11.
//  Copyright © 2018 Mackarous. All rights reserved.
//

import XCTest
@testable import Torrential

class BdecoderListTests: XCTestCase {
    
    private let bdecoder = Bdecoder()
    
    func testBencodedListSuccess() {
        do {
            let sut = "li42e5:stuffi666ee"
            let result = try bdecoder.decode(sut)
            XCTAssertEqual(result, BencodeType.list([.integer(42), .string("stuff"), .integer(666)]))
        } catch {
            XCTFail("Expected success, but test failed with error: \(error)")
        }
    }
    
    func testBencodedListInvalidIndex() {
        do {
            let sut = "li42e5:stuffi666e"
            let result = try bdecoder.decode(sut)
            XCTFail("Expected failure, but test succeeded with result: \(result)")
        } catch let e as Bdecoder.Error {
            XCTAssertEqual(e, .invalidList)
        } catch {
            XCTFail("Expected failure of type \(Bdecoder.Error.invalidList), but test failed with wrong error type: \(error)")
        }
    }
    
    func testBencodedListInvalidStringLength() {
        do {
            let sut = "li42e5r4:stuffi666ee"
            let result = try bdecoder.decode(sut)
            XCTFail("Expected failure, but test succeeded with result: \(result)")
        } catch let e as Bdecoder.Error {
            XCTAssertEqual(e, .invalidStringLength)
        } catch {
            XCTFail("Expected failure of type \(Bdecoder.Error.invalidStringLength), but test failed with wrong error type: \(error)")
        }
    }
    
    func testBencodedListInvalidInteger() {
        do {
            let sut = "li4d2e5:stuffi666ee"
            let result = try bdecoder.decode(sut)
            XCTFail("Expected failure, but test succeeded with result: \(result)")
        } catch let e as Bdecoder.Error {
            XCTAssertEqual(e, .invalidInteger)
        } catch {
            XCTFail("Expected failure of type \(Bdecoder.Error.invalidInteger), but test failed with wrong error type: \(error)")
        }
    }
    
    func testBencodedListMissingToken() {
        do {
            let sut = "li42e5:stuff666ee"
            let result = try bdecoder.decode(sut)
            XCTFail("Expected failure, but test succeeded with result: \(result)")
        } catch let e as Bdecoder.Error {
            XCTAssertEqual(e, .missingToken)
        } catch {
            XCTFail("Expected failure of type \(Bdecoder.Error.missingToken), but test failed with wrong error type: \(error)")
        }
    }
}
