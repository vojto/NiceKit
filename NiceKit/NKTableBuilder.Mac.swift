//
//  NKTableBuilder.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 05/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation
import CoreGraphics
import AppKit


public class NKTableBuilder: NSObject, NSTableViewDataSource, NSTableViewDelegate {

    // MARK: - Properties
    // ------------------------------------------------------------------------

    // Core props
    public let scrollView: NSScrollView
    public let tableView: NKTableView
    public let mainView: NKView
    public var items = [NKTableItem]() {
        didSet {
            reload()
        }
    }
    let hiddenIndexes = NSMutableIndexSet()

    // UI
    public var showsVerticalScrollIndicator: Bool = false // Doesn't do anything
    public var padding: NKPadding? {
        didSet { setPadding(padding: padding!) } // TODO: This should be done through styles
    }
    public var enableReordering: Bool = false {
        didSet { applyEnableReordering(enable: enableReordering) }
    }
    public var menu: NSMenu? {
        get { return self.tableView.menu }
        set { self.tableView.menu = newValue }
    }
    public var columnWidth: CGFloat { return tableView.tableColumns[0].width }

    // Classic API
    public var numberOfSections: (() -> Int)?
    public var numberOfRows: ((_ section: Int) -> Int)?
    public var itemForRow: ((_ section: Int, _ row: Int) -> NKTableItem)?

    // Section headers
    public var viewForHeader: ((_ section: Int) -> NKView)?
    public var headerHeight: CGFloat?

    // Height
    public var calcRowHeight: ((_ row: Int) -> CGFloat)?
    public var rowHeight: CGFloat?

    // Selecting
    public var onSelectRow: ((_ index: Int) -> ())?
    public var onDeselectRow: (() -> ())?
    public var selectedView: NKTableCellView?
    @objc dynamic var _selectionIndexes: NSIndexSet?

    // Events
    public var onTap: (() -> ())?                      // iOS only - doesn't do anything here
    public var onTapOut: (() -> ())?                   // iOS only - doesn't do anything here
    public var onDelete: ((_ row: Int) -> ())?           // TODO: Implement
    public var onScroll: ((_ offset: CGPoint) -> ())?    // Not sure about this one
    public var onStartScrolling: NKSimpleCallback?
    public var onDoubleClick: (() -> ())? {
        get { return tableView.onDoubleClick }
        set { tableView.onDoubleClick = newValue }
    }
    public var onMenu: ((Int) -> (NSMenu?))? {
        get { return tableView.onMenu }
        set { tableView.onMenu = newValue }
    }

    
    // Reordering callbacks
    public var canMoveItem: ((_ at: Int) -> Bool)?
    public var targetRowForMove: ((_ from: Int, _ to: Int) -> Int)?    // Not used here, TODO: make it somehow work with iOS
    public var canDropItem: ((_ from: Int, _ to: Int) -> Bool)?
    public var moveItem: ((_ atIndex: Int, _ toIndex: Int) -> ())?



    // MARK: - Lifecycle
    // ------------------------------------------------------------------------

    public override init() {
        scrollView = NSScrollView.init()
        tableView = NKTableView.init()
        mainView = NKView()
        mainView.addSubview(scrollView)
        scrollView.expand()
        
        super.init()

        let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "column"))
        column.resizingMask = NSTableColumn.ResizingOptions.autoresizingMask
        tableView.addTableColumn(column)

        tableView.selectionHighlightStyle = .none
        tableView.intercellSpacing = CGSize(width: 0, height: 0)
        
        tableView.delegate = self
        tableView.dataSource = self

        
        tableView.headerView = nil
        scrollView.documentView = tableView

        tableView.bind(NSBindingName(rawValue: "selectionIndexes"), to: self, withKeyPath: "_selectionIndexes", options: nil)
        self.addObserver(self, forKeyPath: "_selectionIndexes", options: .new, context: nil)
    }

    public func reload() {
//        NiceKit.log?("Reloading! 😈")

        hiddenIndexes.removeAllIndexes()

        let indexes = tableView.selectedRowIndexes

        tableView.reloadData()
        tableView.layoutSubtreeIfNeeded()

        self.reselectIndexes(proposedIndexes: indexes as NSIndexSet)

//        NSTimer.schedule(delay: 0.1) { _ in
//            // - Come on Vojto, this code is shit and you know it!
//            // - But it works.
//            self.reselectIndexes(indexes)
//        }

    }

    // MARK: Public API
    // ------------------------------------------------------------------------

    public func viewAt(index: Int) -> NSView? {
        return tableView.view(atColumn: 0, row: index, makeIfNecessary: false)
    }

    public func indexForView(view: NKTableCellView) -> Int? {
        return items.index { $0.view == view }
    }
    

    // MARK: - UI Helpers
    // ------------------------------------------------------------------------

    func setPadding(padding: NKPadding) {
        if let padding = self.padding {
            self.scrollView.automaticallyAdjustsContentInsets = false
            self.scrollView.contentInsets = padding.edgeInsets
        } else {
            self.scrollView.automaticallyAdjustsContentInsets = true
        }
    }

    func applyEnableReordering(enable: Bool) {
        if enable {
            tableView.registerForDraggedTypes([NSPasteboard.PasteboardType(rawValue: "public.data")])
        } else {
            tableView.unregisterDraggedTypes()
        }
    }

    // MARK: - Main data source methods
    // ------------------------------------------------------------------------

    
    
    
    @nonobjc public func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        if isCustomMode {
            return self.numberOfRowsInCustomMode()
        } else {
            return items.count
        }
    }
    
    public func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {

        // Return the header view if that's the case
        if isCustomMode {
            let (section, row) = self.indexPathAtOuterRow(row: row)
            if row == 0 {
                return self.viewForHeader!(section)
            }

        }

        let item = self.itemAt(row: row)

        let identifier = String(describing: item.viewClass)
        var view = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: identifier), owner: self) as! NKTableCellView?

        if view == nil {
//            Log.t("Initializing viewg mit identifier: \(identifier)")
            view = item.viewClass!.init(reuseIdentifier: identifier)
            view!.builder = self
        } else {
//            Log.t("Reused view mit identifier: \(identifier) = \(view)")
        }

        item.view = view

        view!.update(item)
        
        return view
    }
    
    public func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        let height = heightForRowAt(row: row)

        if height == 0 {
            return 1
        } else {
            return height
        }
    }

    func heightForRowAt(row: Int) -> CGFloat {
        if hiddenIndexes.contains(row) {
            return 1
        }

        if let height = self.rowHeight {
            return height
        }

        let item = itemAt(row: row)

        if let height = item.height {
            return height
        }

        if self.calcRowHeight != nil {
            return self.calcRowHeight!(row)
        } else {
            return 22.0
        }
    }



    // MARK: Accessing items
    // ------------------------------------------------------------------------

    public func itemAt(row: Int) -> NKTableItem {
        if isCustomMode {
            return self.itemForCustomModeAt(outerRow: row)
        } else {
            return items[row]
        }
    }




    // MARK: Custom mode functionality
    // ------------------------------------------------------------------------

    var isCustomMode: Bool {
        return numberOfRows != nil
    }

    // MARK: Sections cache

    var cachedSections: [Int]?

    func buildSectionsCache() {
        cachedSections = [Int]()

        
        for i in 0 ..< self.numberOfSections!() {
            let count = self.numberOfRows!(i) + 1
            cachedSections?.append(count)
        }
    }

    // MARK: Getting numbers

    func numberOfRowsInCustomMode() -> Int {
        if cachedSections == nil {
            buildSectionsCache()
        }

        return cachedSections!.reduce(0) { $0 + $1 }
    }

    func itemForCustomModeAt(outerRow: Int) -> NKTableItem {
        // Find section

        let (section, row) = indexPathAtOuterRow(row: outerRow)

        if section == 0 {
            return NKTableItem()
        } else {
            return self.itemForRow!(section, row - 1)
        }
    }

    func indexPathAtOuterRow(row: Int) -> (Int, Int) {
        var totalRow = 0

        for i in 0 ..< cachedSections!.count {
            let sectionRows = cachedSections![i]
            totalRow += sectionRows

            if row < totalRow {
                return (i, row - (totalRow - sectionRows))
            }
        }

        fatalError("Outer row out of bounds")
    }


    // MARK: Selecting items
    // ------------------------------------------------------------------------

    public var selectedRow: Int? {
        return tableView.selectedRow
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        handleSelectionChange(indexes: tableView.selectedRowIndexes as NSIndexSet)
    }

    public func selectRow(index: Int) {
        selectIndexes(indexes: NSIndexSet(index: index))
    }

    public func selectIndexes(indexes: NSIndexSet) {
        tableView.selectRowIndexes(indexes as IndexSet, byExtendingSelection: false)

        handleSelectionChange(indexes: indexes)
    }

    public func reselectIndexes(proposedIndexes: NSIndexSet) {
        let indexes = indexesForReselection(indexes: proposedIndexes)

        selectIndexes(indexes: indexes)
    }

    func indexesForReselection(indexes: NSIndexSet) -> NSIndexSet {
        if indexes.count > 0 {
            var index = indexes.firstIndex

            var item: NKTableItem!

            while true {
                item = itemAt(row: index)

                if item.selectable {
                    return NSIndexSet(index: index)
                } else {
                    if index - 1 >= 0 {
                        index = index - 1
                    } else {
                        return NSIndexSet()
                    }
                }
            }
        }

        return NSIndexSet()
    }

    public func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        let item = self.itemAt(row: row)
        return item.selectable
    }

    func handleSelectionChange(indexes: NSIndexSet) {
        if indexes.count > 0 {
//            Log.w("Selection just changed to: \(indexes.firstIndex)")

            let item = self.itemAt(row: indexes.firstIndex)
            if let view = item.view {
                self.makeViewSelected(view: view)
            }

            onSelectRow?(indexes.firstIndex)
        } else {
//            Log.w("Deselected")

            self.resetSelectedView()

            onDeselectRow?()
        }
    }

    public func deselect() {
        fatalError("Deselect not implemented yet")
    }

    func makeViewSelected(view: NKTableCellView) {
        if let currentView = self.selectedView {
            currentView.setSelected(false, animated: false)
        }

        view.setSelected(true, animated: false)

        self.selectedView = view
    }

    func resetSelectedView() {
        if let currentView = self.selectedView {
            currentView.setSelected(false, animated: false)
        }
    }

    /*
    func markSelectedView(indexes: NSIndexSet) {
        forgetSelectedView()

        if indexes.count > 0 {
            let index = indexes.firstIndex

            if let view = tableView.viewAtColumn(0, row: index, makeIfNecessary: false) as? NKTableCellView {
                view.selected = true
                selectedView = view
            }
            
        }
    }

    func forgetSelectedView() {
        selectedView?.selected = false
        selectedView = nil
    }
    */

    
    
    // MARK: Recalculating heights
    
    public func recalculateHeightForView(view: NKTableCellView) {
        let indexes = NSMutableIndexSet()
        
        self.tableView.enumerateAvailableRowViews { rowView, index in
            if view.isDescendant(of: rowView) {
                indexes.add(index)
            }
        }
        
        recalculateHeights(indexes: indexes)
    }
    
    public func recalculateAllHeights() {
        let indexes = NSIndexSet(indexesIn: NSMakeRange(0, tableView.numberOfRows))
        recalculateHeights(indexes: indexes)
    }
    
    public func recalculateHeights(indexes: NSIndexSet) {
        let context = NSAnimationContext.current
        
        NSAnimationContext.beginGrouping()
        context.duration = 0
        
        self.tableView.noteHeightOfRows(withIndexesChanged: indexes as IndexSet)
        
        NSAnimationContext.endGrouping()
    }
    
    // MARK: Reordering
    
    public func tableView(_ tableView: NSTableView, pasteboardWriterForRow row: Int) -> NSPasteboardWriting? {
        if !enableReordering {
            return nil
        }
        
        var canMove = true
        
        if let fun = self.canMoveItem {
            canMove = fun(row)
        }
        
        if canMove {
            let item = NSPasteboardItem()
            item.setString(String(row), forType: NSPasteboard.PasteboardType(rawValue: "public.data"))
            return item
        } else {
            return nil
        }
        
    }
    
    public func tableView(_ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableView.DropOperation) -> NSDragOperation {
        var canMove = true

        if let contents = info.draggingPasteboard().string(forType: NSPasteboard.PasteboardType(rawValue: "public.data")) {
            let index = Int(contents)
        
            if let fun = self.canDropItem {
                canMove = fun(index!, row)
            }
            
            if canMove && dropOperation == .above {
                return .move
            } else {
                return []
            }

        }

        return []
    }
    
    public func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableView.DropOperation) -> Bool {
        
        fatalError("this is broken")
        
        var oldIndexes = [Int]()
        
        info.enumerateDraggingItems(options: .concurrent, for: tableView, classes: [NSPasteboardItem.self], searchOptions: [:]) { arg1, arg2, arg3 in
            
//            if let index = Int(arg1.0.item as! NSPasteboardItem).string(forType: "public.data")!) {
//
//                oldIndexes.append(index)
//            }
        }
        
        var oldIndexOffset = 0
        var newIndexOffset = 0
        
        
        // For simplicity, the code below uses `tableView.moveRowAtIndex` to move rows around directly.
        // You may want to move rows in your content array and then call `tableView.reloadData()` instead.
        tableView.beginUpdates()
        for oldIndex in oldIndexes {
            if oldIndex < row {
//                tableView.moveRowAtIndex(oldIndex + oldIndexOffset, toIndex: row - 1)
                self.moveItem(oldIndex + oldIndexOffset, toIndex: row - 1)
                oldIndexOffset -= 1
            } else {
//                tableView.moveRowAtIndex(oldIndex, toIndex: row + newIndexOffset)
                self.moveItem(oldIndex, toIndex: row + newIndexOffset)
                newIndexOffset += 1
            }
        }
        
        tableView.endUpdates()
        
        return true
    }
    
    func moveItem(_ atIndex: Int, toIndex: Int) {
        if let fun = self.moveItem {
            fun(atIndex, toIndex)
        }
    }

    public func toggleReordering() { // Doesn't do anything on Mac
    }

    // MARK: Hiding/showing rows
    // -----------------------------------------------------------------------

    public func hideRowAt(index: Int) {
        if hiddenIndexes.contains(index) {
            return
        }

        hiddenIndexes.add(index)

        if let view = itemAt(row: index).view {
            view.isHidden = true
        }

        recalculateAllHeights()
    }

    public func unhideRowAt(index: Int) {
        if !hiddenIndexes.contains(index) {
            return
        }

        hiddenIndexes.remove(index)

        if let view = itemAt(row: index).view {
            view.isHidden = false
        }
        
        recalculateAllHeights()
    }

    public func isRowHidden(index: Int) -> Bool {
        return hiddenIndexes.contains(index)
    }

    // MARK: Scrolling
    // -----------------------------------------------------------------------

    public func scrollToBottom() {
        let rows = tableView.numberOfRows
        tableView.scrollRowToVisible(rows - 1)
    }
}


class NKTableRowView: NSTableRowView {
    var isLast = false
    var drawSelection: ((_ rect: NSRect) -> ())?
    
    override func drawSelection(in dirtyRect: NSRect) {
        self.drawSelection?(self.bounds)
    }

    override func drawSeparator(in dirtyRect: NSRect) {
        if !isLast {
            super.drawSeparator(in: dirtyRect)
        }
    }
}
