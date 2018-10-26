//
//  ExtensionTests.swift
//  TorrentialTests
//
//  Created by Andrew Mackarous on 2018-10-26.
//  Copyright © 2018 Mackarous. All rights reserved.
//

@testable import Torrential
import XCTest

final class ExtensionTests: XCTestCase {

    func testSequenceKeypath() {
        struct Foo {
            let bar: Int
        }
        let foo: [Foo] = [Foo(bar: 0), Foo(bar: 1), Foo(bar: 2), Foo(bar: 3)]
        XCTAssertEqual(foo.map(\.bar).count, 4)
        XCTAssertEqual(foo.map(\.bar).first, 0)
        XCTAssertEqual(foo.map(\.bar).last, 3)
    }
    
    func testByteCountStringValue() {
        let kb = 1000
        let mb = 1_000_000
        let gb = 1_000_000_000
        XCTAssertEqual(kb.byteCountStringValue, "1 KB")
        XCTAssertEqual(mb.byteCountStringValue, "1 MB")
        XCTAssertEqual(gb.byteCountStringValue, "1 GB")
        XCTAssertEqual((gb * 10).byteCountStringValue, "10 GB")
    }
    
    func testDateStringValue() {
        guard Locale.current.identifier == "en_CA" else { return }
        let friday26October2018 = Date(timeIntervalSince1970: 1540591661)
        let dateString = friday26October2018.stringValue
        XCTAssertEqual("Friday, October 26, 2018 at 18:07:41 EDT", dateString)
    }
}
