//
//  Sequence+KeyPath.swift
//  Torrential
//
//  Created by Andrew Mackarous on 2018-10-26.
//  Copyright © 2018 Mackarous. All rights reserved.
//

import Foundation

extension Sequence {
    func map<T>(_ keyPath: KeyPath<Element, T>) -> [T] {
        return map { $0[keyPath: keyPath] }
    }
    
    func compactMap<T>(_ keyPath: KeyPath<Element, T?>) -> [T] {
        return compactMap { $0[keyPath: keyPath] }
    }
}
