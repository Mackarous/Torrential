//
//  StringValue.swift
//  Torrential
//
//  Created by Andrew Mackarous on 2018-10-26.
//  Copyright © 2018 Mackarous. All rights reserved.
//

import Foundation

extension Int {
    var stringValue: String {
        return String(self)
    }
    
    var byteCountStringValue: String {
        return Int64(self).byteCountStringValue
    }
}

extension Int64 {
    var byteCountStringValue: String {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        return formatter.string(fromByteCount: self)
    }
}

extension Date {
    var stringValue: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .long
        return formatter.string(from: self)
    }
}
