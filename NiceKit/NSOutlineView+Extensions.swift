//
//  NSOutlineView+Extensions.swift
//  NiceKit
//
//  Created by Vojtech Rinik on 4/25/17.
//  Copyright © 2017 Median. All rights reserved.
//

import Foundation

public extension NSOutlineView {
    func edit(at row: Int, column: Int) {
        if row == -1 {
            return
        }
        
        let view = self.view(atColumn: column, row: row, makeIfNecessary: false)
        
        if let editableView = view as? EditableTableCellView {
            editableView.startEditing()
        }
        
//        guard let view = view as? EditableTableCellView else { return assertionFailure() }
//        view.startEditing()
    }
        
    
    public func select(row: Int) {
        var row = row
        let total = numberOfRows
        
        if row >= numberOfRows {
            row = total - 1
        }
        
        selectRowIndexes(IndexSet([row]), byExtendingSelection: false)
    }
}
