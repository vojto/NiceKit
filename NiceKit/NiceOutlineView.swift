//
//  NiceOutlineView.swift
//  NiceKit
//
//  Created by Vojtech Rinik on 6/30/17.
//  Copyright © 2017 Median. All rights reserved.
//

import Cocoa

open class NiceOutlineView: NSOutlineView {

    open func edit(at row: Int, column: Int) {
        if row == -1 {
            return
        }
        
        let view = self.view(atColumn: column, row: row, makeIfNecessary: false)
        
        if let editableView = view as? EditableTableCellView {
            editableView.startEditing()
        }
    }
    
    
    open func select(row: Int) {
        var row = row
        let total = numberOfRows
        
        if row >= numberOfRows {
            row = total - 1
        }
        
        selectRowIndexes(IndexSet([row]), byExtendingSelection: false)
    }
    
}
