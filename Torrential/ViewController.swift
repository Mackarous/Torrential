//
//  ViewController.swift
//  Torrential
//
//  Created by Andrew Mackarous on 2018-10-11.
//  Copyright © 2018 Mackarous. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let stuff = try loadTest()!
            print(stuff)
        } catch {
            print(error)
        }
    }
    
    private func loadTest() throws -> BencodeType? {
        guard let url = Bundle.main.url(forResource: "bunny", withExtension: "torrent") else { return nil }
        let data = try Data(contentsOf: url)
        guard let string = String(data: data, encoding: .ascii) else { return nil }
        let decoder = Bdecoder()
        return try decoder.decode(string)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

