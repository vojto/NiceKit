//
//  CustomTableRowView.swift
//  FocusPlan
//
//  Created by Vojtech Rinik on 5/11/17.
//  Copyright © 2017 Median. All rights reserved.
//

import Foundation
import AppKit

class EditableTableRowView: NSTableRowView {
    var isEditing = false
}

class CustomTableRowView: EditableTableRowView {
    override var isSelected: Bool {
        didSet {
            needsDisplay = true
        }
    }
    
    override var isEditing: Bool {
        didSet {
            needsDisplay = true
        }
    }
    
    let blue = NSColor(hexString: "A6CAFD")!.withAlphaComponent(0.3)
    
    override func drawBackground(in dirtyRect: NSRect) {
        let rect = bounds.insetBy(dx: 4, dy: 4)
        let path = NSBezierPath(roundedRect: rect, cornerRadius: 3)
        
        if isEditing {
            NSColor.white.set()
            NSRectFill(bounds)
            
            blue.setStroke()
            path.stroke()
        } else if isSelected {
            NSColor.white.set()
            NSRectFill(bounds)
            
            blue.setFill()
            path.fill()
        } else {
            NSColor.white.set()
            NSRectFill(bounds)
        }
    }
}
