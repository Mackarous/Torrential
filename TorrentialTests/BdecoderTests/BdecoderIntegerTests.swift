//
//  TorrentialTests.swift
//  TorrentialTests
//
//  Created by Andrew Mackarous on 2018-10-11.
//  Copyright © 2018 Mackarous. All rights reserved.
//

import XCTest
@testable import Torrential

class BdecoderIntegerTests: XCTestCase {
    
    private let bdecoder = Bdecoder()
    
    func testBencodedIntegerSuccess() {
        do {
            let sut = "i345e"
            let result = try bdecoder.decode(sut)
            XCTAssertEqual(result, BencodeType.integer(345))
        } catch {
            XCTFail("Expected success, but test failed with error: \(error)")
        }
    }
    
    func testBencodedIntegerMissingEndToken() {
        do {
            let sut = "i567"
            let result = try bdecoder.decode(sut)
            XCTFail("Expected failure, but test succeeded with result: \(result)")
        } catch let e as Bdecoder.Error {
            XCTAssertEqual(e, .missingToken)
        } catch {
            XCTFail("Expected failure of type \(Bdecoder.Error.missingToken), but test failed with wrong error type: \(error)")
        }
    }
    
    func testBencodedIntegerInvalidInteger() {
        do {
            let sut = "i54hu890e"
            let result = try bdecoder.decode(sut)
            XCTFail("Expected failure, but test succeeded with result: \(result)")
        } catch let e as Bdecoder.Error {
            XCTAssertEqual(e, .invalidInteger)
        } catch {
            XCTFail("Expected failure of type \(Bdecoder.Error.invalidInteger), but test failed with wrong error type: \(error)")
        }
    }
}
