//
//  TorrentMetadataTests.swift
//  TorrentialTests
//
//  Created by Andrew Mackarous on 2018-10-26.
//  Copyright © 2018 Mackarous. All rights reserved.
//

@testable import Torrential
import XCTest

final class TorrentMetadataTests: XCTestCase {
    
    private let reader = TorrentReader()

    func testBunnyTorrent() {
        let bundle = Bundle(for: TorrentMetadataTests.self)
        let url = bundle.url(forResource: "bunny", withExtension: "torrent")
        XCTAssertNotNil(url)
        let metadata = reader.loadTorrentMetadata(from: url!)
        XCTAssertNotNil(metadata)
        XCTAssertEqual(metadata?.createdBy, "uTorrent/3320")
        XCTAssertEqual(metadata?.creationDate?.timeIntervalSince1970, 1387309701)
        XCTAssertEqual(metadata?.info.pieceLength, 524288)
        XCTAssertEqual(metadata?.info.pieces?.count, 16600)
//        XCTAssertEqual(<#T##expression1: Equatable##Equatable#>, <#T##expression2: Equatable##Equatable#>)
    }
}
