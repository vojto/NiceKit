//
//  TasksOutlineView.swift
//  NiceKit
//
//  Created by Vojtech Rinik on 6/16/17.
//  Copyright © 2017 Vojtech Rinik. All rights reserved.
//

import Foundation
import AppKit

open class EditableOutlineView: NiceOutlineView {
    open var editedCellView: EditableTableCellView?

    open var isEditing: Bool {
        return editedCellView != nil
    }

    
    override open func mouseDown(with event: NSEvent) {
        let point    = convert(event.locationInWindow, from: nil)
        let rowIndex = row(at: point)
        let columnIndex = column(at: point)
        let selectedIndex = selectedRow
        
        super.mouseDown(with: event)
        
        if isEditing {
            return
        }
        
        let finalPoint = convert(window!.mouseLocationOutsideOfEventStream, from: nil)
        //        let finalRowIndex = row(at: finalPoint)
        
        let deltaX = abs(finalPoint.x - point.x)
        let deltaY = abs(finalPoint.y - point.y)
        
        if deltaX < 2, deltaY < 2, rowIndex == selectedIndex {
            edit(at: rowIndex, column: columnIndex)
        }
    }

}
