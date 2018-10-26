//
//  TorrentReader.swift
//  Torrential
//
//  Created by Andrew Mackarous on 2018-10-18.
//  Copyright © 2018 Mackarous. All rights reserved.
//

import Foundation

struct TorrentReader {
    enum Error: LocalizedError {
        case malformedData, invalidMetadata
        
        var errorDescription: String? {
            switch self {
            case .malformedData:
                return "The data in the Bencoded file is malformed. Could not encode to ASCII."
            case .invalidMetadata:
                return "There was an error parsing the metadata. No data was found."
            }
        }
    }
    
    private let decoder = Bdecoder()
    
    func loadTorrentMetadata(from url: URL) throws -> TorrentMetadata {
        let data = try Data(contentsOf: url)
        guard let string = String(data: data, encoding: .ascii) else { throw Error.malformedData }
        let result = try decoder.decode(string)
        guard let metadata = TorrentMetadata(bencodeType: result) else { throw Error.invalidMetadata }
        return metadata
    }
}
