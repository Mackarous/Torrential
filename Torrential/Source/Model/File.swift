//
//  File.swift
//  Torrential
//
//  Created by Andrew Mackarous on 2018-10-26.
//  Copyright © 2018 Mackarous. All rights reserved.
//

import Foundation

struct File: Hashable {
    let name: String
    let size: Int
    let checksum: String
    let files: [File]
}
