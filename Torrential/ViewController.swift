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
//        view.registerForDraggedTypes([.fileURL])
    }
    
    @IBAction func openFile(_ sender: Any) {
        let panel = NSOpenPanel()
        panel.allowedFileTypes = ["torrent"]
        let clicked = panel.runModal()
        guard clicked == .OK, let url = panel.url else { return }
        let reader = TorrentReader(fileURL: url)
        let torrentData = reader.loadTorrentMetadata()
        print(torrentData)
    }
}

