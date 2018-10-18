//
//  TorrentialTests.swift
//  TorrentialTests
//
//  Created by Andrew Mackarous on 2018-10-11.
//  Copyright © 2018 Mackarous. All rights reserved.
//

import XCTest
@testable import Torrential

class BdecoderStringTests: XCTestCase {
    
    private let bdecoder = Bdecoder()

    func testBencodedStringSuccess() {
        do {
            let sut = "6:string"
            let result = try bdecoder.decode(sut)
            XCTAssertEqual(result, BencodeType.string("string"))
        } catch {
            XCTFail("Expected success, but test failed with error: \(error)")
        }
    }
    
    func testBencodedStringMissingColon() {
        do {
            let sut = "6string"
            let result = try bdecoder.decode(sut)
            XCTFail("Expected failure, but test succeeded with result: \(result)")
        } catch let e as Bdecoder.Error {
            XCTAssertEqual(e, .missingToken)
        } catch {
            XCTFail("Expected failure of type \(Bdecoder.Error.missingToken), but test failed with wrong error type: \(error)")
        }
    }
    
    func testBencodedStringInvalidStringLength() {
        do {
            let sut = "6r5:string"
            let result = try bdecoder.decode(sut)
            XCTFail("Expected failure, but test succeeded with result: \(result)")
        } catch let e as Bdecoder.Error {
            XCTAssertEqual(e, .invalidStringLength)
        } catch {
            XCTFail("Expected failure of type \(Bdecoder.Error.missingToken), but test failed with wrong error type: \(error)")
        }
    }
}
