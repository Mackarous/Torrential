//
//  TorrentMetadataViewController.swift
//  Torrential
//
//  Created by Andrew Mackarous on 2018-10-11.
//  Copyright © 2018 Mackarous. All rights reserved.
//

import Cocoa

final class TorrentMetadataViewController: NSViewController {
    private enum ColumnIdentifier: String {
        case name, length, md5sum
    }
    
    @IBOutlet private var createdByField: NSTextField!
    @IBOutlet private var creationDateField: NSTextField!
    @IBOutlet private var trackerURLField: NSTextField!
    @IBOutlet private var outlineView: NSOutlineView!
    
    private let reader = TorrentReader()
    private var directory = [File]()
    
    @IBAction func openFile(_ sender: Any) {
        let panel = NSOpenPanel()
        panel.allowedFileTypes = ["torrent"]
        let clicked = panel.runModal()
        guard clicked == .OK, let url = panel.url else { return }
        guard let metadata = reader.loadTorrentMetadata(from: url) else { return }
        configure(metadata)
        outlineView.reloadData()
    }
    
    private func configure(_ metadata: TorrentMetadata) {
        createdByField.stringValue = metadata.createdBy ?? "Unkown"
        creationDateField.stringValue = metadata.creationDate?.stringValue ?? "Unknown"
        trackerURLField.stringValue = metadata.announce ?? "Unknown"
        directory = parseDirectory(from: metadata)
    }
    
    private func parseDirectory(from metadata: TorrentMetadata) -> [File] {
        let rootFiles = metadata.info.files
            .filter { $0.path.count == 1 }
            .map { File(name: $0.path.first ?? "", length: $0.length?.stringValue ?? "", md5sum: $0.md5sum ?? "") }
        return rootFiles
    }
}

extension TorrentMetadataViewController: NSOutlineViewDataSource {
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        guard let file = item as? File else {
            return directory.count
        }
        return file.files.count
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        guard let file = item as? File else {
            return directory[index]
        }
        return file.files[index]
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        guard let file = item as? File else {
            return false
        }
        return !file.files.isEmpty
    }
}

extension TorrentMetadataViewController: NSOutlineViewDelegate {
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        guard let id = tableColumn?.identifier, let identifier = ColumnIdentifier(rawValue: id.rawValue) else { return nil }
        guard let file = item as? File else { return nil }
        guard let cell = outlineView.makeView(withIdentifier: id, owner: nil) as? NSTableCellView else { return nil }
        switch identifier {
        case .name:
            cell.textField?.stringValue = file.name
        case .length:
            cell.textField?.stringValue = file.length
        case .md5sum:
            cell.textField?.stringValue = file.md5sum
        }
        return cell
    }
}
