//
//  Bencoder.swift
//  Torrential
//
//  Created by Andrew Mackarous on 2018-10-11.
//  Copyright © 2018 Mackarous. All rights reserved.
//

import Foundation

enum BencodedType: Equatable {
    case integer(Int)
    case string(String)
    indirect case list([BencodedType])
    indirect case dictionary([String: BencodedType])
}

struct Bdecoder {
    enum Error: Swift.Error {
        case invalidStringLength
        case malformedBencoding
        case missingToken
    }
    
    private enum Token {
        static let string: ClosedRange<UInt8> = 0x30...0x39 // 0...9
        static let colon: Character = ":"
        static let dictionary: UInt8          = 0x64 // d
        static let end: UInt8                 = 0x65 // e
        static let integer: UInt8             = 0x69 // i
        static let list: UInt8                = 0x6c // l
    }
    
    func decode(_ string: String) throws -> BencodedType {
        return try decode(string, index: 0)
    }
    
    private func decode(_ string: String, index: Int) throws -> BencodedType {
        let bytes = Array(string.utf8)
        let token = bytes[index]
        switch token {
        case Token.string:
            return try parseString(string, fromIndex: index)
        default:
            throw Error.malformedBencoding
        }
    }
    
    private func parseString(_ string: String, fromIndex index: Int) throws -> BencodedType {
        let startIndex = string.index(string.startIndex, offsetBy: index)
        let substring = string[startIndex...]
        guard let colonIndex = substring.firstIndex(of: Token.colon) else { throw Error.missingToken }
        guard let length = Int(substring[substring.startIndex..<colonIndex]) else { throw Error.invalidStringLength }
        let resultIndex = substring.index(colonIndex, offsetBy: 1)
        let endIndex = substring.index(resultIndex, offsetBy: length)
        let result = substring[resultIndex..<endIndex]
        return .string(String(result))
    }
}
