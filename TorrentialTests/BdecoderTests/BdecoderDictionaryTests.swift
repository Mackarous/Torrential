//
//  TorrentialTests.swift
//  TorrentialTests
//
//  Created by Andrew Mackarous on 2018-10-11.
//  Copyright © 2018 Mackarous. All rights reserved.
//

import XCTest
@testable import Torrential

class BdecoderDictionaryTests: XCTestCase {
    
    private let bdecoder = Bdecoder()
    
    func testBencodedDictionarySuccess() {
        do {
            let sut = "d4:testi42e3:zzz4:junke"
            let result = try bdecoder.decode(sut)
            XCTAssertEqual(result, BencodeType.dictionary(["test": .integer(42), "zzz": .string("junk")]))
        } catch {
            XCTFail("Expected success, but test failed with error: \(error)")
        }
    }
    
    func testBencodedDictionaryInvalidIndex() {
        do {
            let sut = "di33ei42e3:zzz4:junke"
            let result = try bdecoder.decode(sut)
            XCTFail("Expected failure, but test succeeded with result: \(result)")
        } catch let e as Bdecoder.Error {
            XCTAssertEqual(e, .invalidDictionaryKey)
        } catch {
            XCTFail("Expected failure of type \(Bdecoder.Error.invalidDictionaryKey), but test failed with wrong error type: \(error)")
        }
    }

    func testBencodedDictionaryInvalidStringLength() {
        do {
            let sut = "d4r5:testi42e3:zzz4:junke"
            let result = try bdecoder.decode(sut)
            XCTFail("Expected failure, but test succeeded with result: \(result)")
        } catch let e as Bdecoder.Error {
            XCTAssertEqual(e, .invalidStringLength)
        } catch {
            XCTFail("Expected failure of type \(Bdecoder.Error.invalidStringLength), but test failed with wrong error type: \(error)")
        }
    }

    func testBencodedDictionaryInvalidInteger() {
        do {
            let sut = "d4:testi4f2e3:zzz4:junke"
            let result = try bdecoder.decode(sut)
            XCTFail("Expected failure, but test succeeded with result: \(result)")
        } catch let e as Bdecoder.Error {
            XCTAssertEqual(e, .invalidInteger)
        } catch {
            XCTFail("Expected failure of type \(Bdecoder.Error.invalidInteger), but test failed with wrong error type: \(error)")
        }
    }

    func testBencodedDictionaryMissingToken() {
        do {
            let sut = "d4:testi42e3:zzz4junke"
            let result = try bdecoder.decode(sut)
            XCTFail("Expected failure, but test succeeded with result: \(result)")
        } catch let e as Bdecoder.Error {
            XCTAssertEqual(e, .missingToken)
        } catch {
            XCTFail("Expected failure of type \(Bdecoder.Error.missingToken), but test failed with wrong error type: \(error)")
        }
    }
}
