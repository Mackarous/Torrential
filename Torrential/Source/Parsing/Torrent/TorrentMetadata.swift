//
//  TorrentMetadata.swift
//  Torrential
//
//  Created by Andrew Mackarous on 2018-10-18.
//  Copyright © 2018 Mackarous. All rights reserved.
//

import Foundation

/// BitTorrent metainfo specification found here: https://wiki.theory.org/index.php/BitTorrentSpecification#Metainfo_File_Structure
struct TorrentMetadata {
    struct File: Equatable, Hashable {
        let path: [String]
        let length: Int?
        let md5sum: String?
        
        init?(name: String?, length: Int?, md5sum: String?) {
            guard let name = name else { return nil }
            path = [name]
            self.length = length
            self.md5sum = md5sum
        }
        
        init(metainfo: [String: BencodeType]) {
            path = metainfo["path"]?.list?.compactMap(\.string) ?? []
            length = metainfo["length"]?.integer
            md5sum = metainfo["md5sum"]?.string
        }
    }
    struct Info {
        let pieceLength: Int?
        let pieces: String?
        let isPrivate: Bool
        let files: [File]
        
        init(metainfo: [String: BencodeType]) {
            pieceLength = metainfo["piece length"]?.integer
            pieces = metainfo["pieces"]?.string
            isPrivate = metainfo["private"]?.integer == 1
            let files = metainfo["files"]?.list?.compactMap(\.dictionary).compactMap(File.init) ?? []
            guard files.isEmpty else {
                self.files = files
                return
            }
            let name = metainfo["name"]?.string
            let length = metainfo["length"]?.integer
            let md5sum = metainfo["md5sum"]?.string
            guard let file = File(name: name, length: length, md5sum: md5sum) else {
                self.files = []
                return
            }
            self.files = [file]
        }
    }
    
    let info: Info
    let announce: String?
    let announceList: [String]
    let createdBy: String?
    let comment: String?
    let encoding: String?
    private(set) var creationDate: Date?
    
    init?(bencodeType: BencodeType) {
        guard let metainfo = bencodeType.dictionary else { return nil }
        guard let info = metainfo["info"]?.dictionary else { return nil }
        self.info = Info(metainfo: info)
        announce = metainfo["announce"]?.string ?? metainfo["url"]?.string
        announceList = metainfo["announce-list"]?.list?.compactMap(\.string)
            ?? metainfo["url-list"]?.list?.compactMap(\.string)
            ?? []
        createdBy = metainfo["created by"]?.string
        if let timeInterval = metainfo["creation date"]?.integer {
            creationDate = Date(timeIntervalSince1970: TimeInterval(timeInterval))
        }
        comment = metainfo["comment"]?.string
        encoding = metainfo["encoding"]?.string
    }
}

