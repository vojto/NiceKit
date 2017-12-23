//
//  NKSimpleTable.swift
//  Median
//
//  Created by Vojtech Rinik on 28/09/2016.
//  Copyright © 2016 Vojtech Rinik. All rights reserved.
//

import Foundation
import CoreGraphics

open class NKSimpleTable<ItemType, ViewType: NSView>: NSScrollView, NSTableViewDataSource, NSTableViewDelegate {
    open var build: ((ItemType) -> (ViewType))!
    open var update: ((ViewType, ItemType, Int) -> ())!
    open var height: ((ItemType) -> CGFloat)?
    open var identify: ((ItemType) -> String)?
    open var canScroll: Bool = true {
        didSet {
            hasVerticalScroller = canScroll
            verticalScrollElasticity = canScroll ? .automatic : .none
        }
    }
    
    open var tableView: NKSimpleTableView!
    
    public var onMenu: ((Int) -> (NSMenu?))? {
        get { return tableView.onMenu }
        set { tableView.onMenu = newValue }
    }
    
    open var items = [ItemType]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    public convenience init() {
        self.init(frame: NSZeroRect)
        
        tableView = NKSimpleTableView(frame: NSZeroRect)
        self.documentView = tableView
        self.drawsBackground = false
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.headerView = nil
        tableView.backgroundColor = NSColor.clear
        tableView.selectionHighlightStyle = .none
        
        
        let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "column"))
        column.resizingMask = NSTableColumn.ResizingOptions.autoresizingMask
        tableView.addTableColumn(column)
    }
    
    public
    func numberOfRows(in tableView: NSTableView) -> Int {
        return items.count
    }
    
    public func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let identifier = self.identify?(items[row]) ?? "view"
        
        var view: ViewType? = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: identifier), owner: self) as! ViewType?
        
        if view == nil {
            view = self.build(items[row])
            view?.identifier = NSUserInterfaceItemIdentifier(rawValue: identifier)
        }
        
        self.update(view!, items[row], row)
        
        return view
    }
    
    public func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return self.calcHeight(row: row)
    }
    
    func calcHeight(row: Int) -> CGFloat {
        return height?(items[row]) ?? 20
    }
    
    open func totalHeight() -> CGFloat {
        return items.enumerated().reduce(0.0, { (sum, item) in
            return sum + self.calcHeight(row: item.0) + self.tableView.intercellSpacing.height
        })
    }
    
    public func reload() {
        tableView.reloadData()
    }

//    override func scrollWheel(with event: NSEvent) {
//        if canScroll {
//            super.scrollWheel(with: event)
//        }
//    }
}

open class NKSimpleTableView: NSTableView {
    var onMenu: ((Int) -> (NSMenu?))?
    
    open override func menu(for event: NSEvent) -> NSMenu? {
        if let onMenu = onMenu {
            let pt = convert(event.locationInWindow, from: nil)
            let row = self.row(at: pt)
            
            return onMenu(row)
        } else {
            return super.menu(for: event)
        }
    }
    
    override open func mouseDown(with event: NSEvent) {
        Swift.print("Mouse down in the table")
    }
    
    override open var acceptsFirstResponder: Bool {
        return false
    }
}
