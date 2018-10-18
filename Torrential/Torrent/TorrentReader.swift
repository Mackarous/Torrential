//
//  TorrentReader.swift
//  Torrential
//
//  Created by Andrew Mackarous on 2018-10-18.
//  Copyright © 2018 Mackarous. All rights reserved.
//

import Foundation

struct TorrentReader {
    private let decoder = Bdecoder()
    let fileURL: URL
    
    func loadTorrentMetadata() -> TorrentMetadata? {
        do {
            let data = try Data(contentsOf: fileURL)
            guard let string = String(data: data, encoding: .ascii) else { return nil }
            let result = try decoder.decode(string)
            return TorrentMetadata(bencodeType: result)
        } catch {
            print(error)
            return nil
        }
    }
}
