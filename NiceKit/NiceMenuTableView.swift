//
//  NicePopoverTableView.swift
//  Timelist
//
//  Created by Vojtech Rinik on 6/20/17.
//  Copyright © 2017 Vojtech Rinik. All rights reserved.
//

import Cocoa

class NiceMenuTableView: NSTableView {

    var trackingArea: NSTrackingArea?
    var onDismiss: (() -> ())?
    
    override open func updateTrackingAreas() {
        if let area = trackingArea {
            removeTrackingArea(area)
        }
        
        trackingArea = NSTrackingArea(rect: bounds, options: [.mouseMoved, .mouseEnteredAndExited, .activeAlways], owner: self, userInfo: nil)
        self.addTrackingArea(trackingArea!)
    }
    
    // MARK: - Handling mouse events
    
    override func mouseMoved(with event: NSEvent) {
        let point = convert(event.locationInWindow, from: nil)
        let hoveredRow = self.row(at: point)
        let selectedRow = self.selectedRow
        
        if hoveredRow != -1 && hoveredRow != selectedRow {
            select(row: hoveredRow)
        }
    }
    
    override func mouseEntered(with event: NSEvent) {
        
    }
    
    override func mouseExited(with event: NSEvent) {
        selectNone()
    }
    
    // MARK: - Handling clicks
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        
        let point = convert(event.locationInWindow, from: nil)
        let row = self.row(at: point)
        
        select(row: row)
        
        onDismiss?()
    }
    
    func selectDefault() {
        let row = self.selectedRow
        
        if row == -1 {
            self.select(row: 0)
        }
    }
    
    func selectNone() {
        self.selectRowIndexes(IndexSet(), byExtendingSelection: false)
    }
    
    func moveSelectionDown() {
        let row = self.selectedRow
        
        if row == -1 {
            select(row: 0)
        } else {
            select(row: row + 1)
        }
        
    }
    
    func moveSelectionUp() {
        let lastRow = numberOfRows - 1
        let row = self.selectedRow
        
        if row == -1 {
            select(row: lastRow)
        } else {
            select(row: row - 1)
        }
    }
    
    func select(row: Int) {
        self.selectRowIndexes([row], byExtendingSelection: false)
    }
    
    override func reloadData() {
        let row = selectedRow
        
        super.reloadData()
        
        if row <= (numberOfRows - 1) {
            select(row: row)
        } else {
            select(row: numberOfRows - 1)
        }
    }
    
}
