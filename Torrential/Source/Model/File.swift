//
//  File.swift
//  Torrential
//
//  Created by Andrew Mackarous on 2018-10-26.
//  Copyright © 2018 Mackarous. All rights reserved.
//

import Foundation

struct File {
    let name: String
    let length: String
    let md5sum: String
    var files = [File]()
    
    init(name: String, length: String, md5sum: String) {
        self.name = name
        self.length = length
        self.md5sum = md5sum
    }
}
