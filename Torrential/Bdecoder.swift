//
//  Bdecoder.swift
//  Torrential
//
//  Created by Andrew Mackarous on 2018-10-11.
//  Copyright © 2018 Mackarous. All rights reserved.
//

import Foundation

enum BencodeType: Equatable {
    case integer(Int)
    case string(String)
    indirect case list([BencodeType])
    indirect case dictionary([String: BencodeType])
    
    var integer: Int? {
        guard case let .integer(i) = self else { return nil }
        return i
    }

    var string: String? {
        guard case let .string(s) = self else { return nil }
        return s
    }

    var list: [BencodeType]? {
        guard case let .list(l) = self else { return nil }
        return l
    }

    var dictionary: [String: BencodeType]? {
        guard case let .dictionary(d) = self else { return nil }
        return d
    }
}

struct Bdecoder {
    enum Error: Swift.Error {
        case invalidDictionaryKey
        case invalidList
        case invalidInteger
        case invalidStringLength
        case malformedBencoding
        case missingToken
    }
    
    private enum Token {
        static let colon: Character               = ":"
        static let string: ClosedRange<Character> = "0"..."9"
        static let dictionary: Character          = "d"
        static let end: Character                 = "e"
        static let integer: Character             = "i"
        static let list: Character                = "l"
    }
    
    typealias DecodeResult = (type: BencodeType, endIndex: Int)
    
    func decode(_ string: String) throws -> BencodeType {
        return try decode(string, index: 0).type
    }
    
    private func decode(_ string: String, index: Int) throws -> DecodeResult {
        let stringIndex = string.index(string.startIndex, offsetBy: index)
        switch string[stringIndex] {
        case Token.string:
            return try parseString(string, fromIndex: index)
        case Token.integer:
            return try parseInteger(string, fromIndex: index)
        case Token.list:
            return try parseList(string, fromIndex: index)
        case Token.dictionary:
            return try parseDictionary(string, fromIndex: index)
        default:
            throw Error.malformedBencoding
        }
    }
    
    private func parseString(_ string: String, fromIndex index: Int) throws -> DecodeResult {
        let startIndex = string.index(string.startIndex, offsetBy: index)
        let substring = string[startIndex...]
        guard let colonIndex = substring.firstIndex(of: Token.colon) else { throw Error.missingToken }
        guard let length = Int(substring[substring.startIndex..<colonIndex]) else { throw Error.invalidStringLength }
        let resultIndex = substring.index(colonIndex, offsetBy: 1)
        let endIndex = substring.index(resultIndex, offsetBy: length)
        let result = substring[resultIndex..<endIndex]
        return (.string(String(result)), endIndex.encodedOffset - 1)
    }
    
    private func parseInteger(_ string: String, fromIndex index: Int) throws -> DecodeResult {
        let startIndex = string.index(string.startIndex, offsetBy: index + 1)
        let substring = string[startIndex...]
        guard let eTokenIndex = substring.firstIndex(of: Token.end) else { throw Error.missingToken }
        let integerString = substring[startIndex..<eTokenIndex]
        guard let integer = Int(integerString) else { throw Error.invalidInteger }
        return (.integer(integer), eTokenIndex.encodedOffset)
    }
    
    private func parseList(_ string: String, fromIndex index: Int) throws -> DecodeResult {
        var startIndex = string.index(string.startIndex, offsetBy: index + 1)
        var listItems = [BencodeType]()
        while string[startIndex] != Token.end {
            let item = try decode(string, index: startIndex.encodedOffset)
            listItems.append(item.type)
            startIndex = string.index(string.startIndex, offsetBy: item.endIndex + 1)
            guard startIndex < string.endIndex else { throw Error.invalidList }
        }
        return (.list(listItems), startIndex.encodedOffset)
    }
    
    private func parseDictionary(_ string: String, fromIndex index: Int) throws -> DecodeResult {
        var startIndex = string.index(string.startIndex, offsetBy: index + 1)
        var dict = [String: BencodeType]()
        while string[startIndex] != Token.end {
            guard Token.string.contains(string[startIndex]) else {
                throw Error.invalidDictionaryKey
            }
            let keyResult = try parseString(string, fromIndex: startIndex.encodedOffset)
            guard case let .string(key) = keyResult.type else {
                throw Error.invalidDictionaryKey
            }
            let valueResult = try decode(string, index: keyResult.endIndex + 1)
            dict[key] = valueResult.type
            startIndex = string.index(string.startIndex, offsetBy: valueResult.endIndex + 1)
            guard startIndex < string.endIndex else { throw Error.invalidList }
        }
        return (.dictionary(dict), startIndex.encodedOffset)
    }
}
