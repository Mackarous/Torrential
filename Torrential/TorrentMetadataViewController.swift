//
//  TorrentMetadataViewController.swift
//  Torrential
//
//  Created by Andrew Mackarous on 2018-10-11.
//  Copyright © 2018 Mackarous. All rights reserved.
//

import Cocoa

final class TorrentMetadataViewController: NSViewController {
    @IBOutlet private var createdByField: NSTextField!
    @IBOutlet private var creationDateField: NSTextField!
    @IBOutlet private var trackerURLField: NSTextField!
    @IBOutlet private var tableView: NSTableView!
    
    private var files = [TorrentMetadata.File]()
    private var tableViewData: [[String: String]] {
        return files.map {
            [
                "name": $0.path.last ?? "",
                "length": $0.length?.stringValue ?? "",
                "md5sum": $0.md5sum ?? ""
            ]
        }
    }
    
    @IBAction func openFile(_ sender: Any) {
        let panel = NSOpenPanel()
        panel.allowedFileTypes = ["torrent"]
        let clicked = panel.runModal()
        guard clicked == .OK, let url = panel.url else { return }
        let reader = TorrentReader(fileURL: url)
        guard let metadata = reader.loadTorrentMetadata() else { return }
        configure(metadata)
        tableView.reloadData()
    }
    
    private func configure(_ metadata: TorrentMetadata) {
        createdByField.stringValue = metadata.createdBy ?? "Unkown"
        creationDateField.stringValue = metadata.creationDate?.stringValue ?? "Unknown"
        trackerURLField.stringValue = metadata.announce ?? "Unknown"
        files = metadata.info.files
    }
}

extension TorrentMetadataViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return files.count
    }
}

extension TorrentMetadataViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let identifier = tableColumn?.identifier else { return nil }
        guard let cell = tableView.makeView(withIdentifier: identifier, owner: nil) as? NSTableCellView else { return nil }
        let item = tableViewData[row][identifier.rawValue]
        cell.textField?.stringValue = item ?? ""
        return cell
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

extension Int {
    var stringValue: String {
        return String(self)
    }
}
