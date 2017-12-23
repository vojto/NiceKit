//
//  NicePopoverTableView.swift
//  NiceKit
//
//  Created by Vojtech Rinik on 6/20/17.
//  Copyright © 2017 Vojtech Rinik. All rights reserved.
//

import Cocoa

public class NiceMenuTableView: NSTableView {

    var trackingArea: NSTrackingArea?
    public var onClickSelected: (() -> ())?

    override open func updateTrackingAreas() {
        if let area = trackingArea {
            removeTrackingArea(area)
        }

        trackingArea = NSTrackingArea(rect: bounds, options: [NSTrackingArea.Options.mouseMoved, NSTrackingArea.Options.mouseEnteredAndExited, NSTrackingArea.Options.activeAlways], owner: self, userInfo: nil)
        self.addTrackingArea(trackingArea!)
    }

    // MARK: - Handling mouse events

    override open func mouseMoved(with event: NSEvent) {
        let point = convert(event.locationInWindow, from: nil)
        let hoveredRow = self.row(at: point)
        let selectedRow = self.selectedRow

        if hoveredRow != -1 && hoveredRow != selectedRow {
            select(row: hoveredRow)
        }
    }

    override open func mouseEntered(with event: NSEvent) {

    }

    override open func mouseExited(with event: NSEvent) {
        selectNone()
    }

    // MARK: - Handling clicks

    override open func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)

        let point = convert(event.locationInWindow, from: nil)
        let row = self.row(at: point)

        select(row: row)

        onClickSelected?()
    }

    public func selectDefault() {
        let row = self.selectedRow

        if row == -1 {
            self.select(row: 0)
        }
    }

    public func selectNone() {
        self.selectRowIndexes(IndexSet(), byExtendingSelection: false)
    }

    public func moveSelectionDown() {
        let row = self.selectedRow

        if row == -1 {
            select(row: 0)
        } else {
            select(row: row + 1)
        }

    }

    public func moveSelectionUp() {
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

    override open func reloadData() {
        let row = selectedRow

        super.reloadData()

        if row <= (numberOfRows - 1) {
            select(row: row)
        } else {
            select(row: numberOfRows - 1)
        }
    }

}

