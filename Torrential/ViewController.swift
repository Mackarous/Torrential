//
//  ViewController.swift
//  Torrential
//
//  Created by Andrew Mackarous on 2018-10-11.
//  Copyright © 2018 Mackarous. All rights reserved.
//

import Cocoa

final class ViewController: NSViewController {
    @IBOutlet private var createdByField: NSTextField!
    @IBOutlet private var creationDateField: NSTextField!
    @IBOutlet private var trackerURLField: NSTextField!

    @IBAction func openFile(_ sender: Any) {
        let panel = NSOpenPanel()
        panel.allowedFileTypes = ["torrent"]
        let clicked = panel.runModal()
        guard clicked == .OK, let url = panel.url else { return }
        let reader = TorrentReader(fileURL: url)
        guard let metadata = reader.loadTorrentMetadata() else { return }
        configure(metadata)
    }
    
    private func configure(_ metadata: TorrentMetadata) {
        createdByField.stringValue = metadata.createdBy ?? "Unkown"
        creationDateField.stringValue = metadata.creationDate?.stringValue ?? "Unknown"
        trackerURLField.stringValue = metadata.announce ?? "Unknown"
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
