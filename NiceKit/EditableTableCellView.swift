//
//  EditableTableCellView.swift
//  FocusPlan
//
//  Created by Vojtech Rinik on 4/26/17.
//  Copyright © 2017 Median. All rights reserved.
//

import Foundation
import AppKit

open class EditableTableCellView: NSTableCellView, NSTextFieldDelegate {
    var node: NSTreeNode?
    public var outlineView: NSOutlineView?
    var isEditing = false
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        textField?.delegate = self
    }
    
    override open func controlTextDidEndEditing(_ obj: Notification) {
        self.finishEditing()
    }
    
    override open func controlTextDidChange(_ obj: Notification) {
    }
    
    public func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if commandSelector == #selector(NSControl.cancelOperation(_:)) {
            window?.makeFirstResponder(nil)
            
            return true
        }
        
        return false
    }
    
    open func startEditing() {
        guard let field = textField else { return }
        
        field.delegate = self
        
        field.isEditable = true
        window?.makeFirstResponder(field)
        
        rowView?.isEditing = true
        
        isEditing = true
        
        (outlineView as? EditableOutlineView)?.isEditing = true
    }
    
    open func finishEditing() {
        guard let field = textField else { return }
        
        field.resignFirstResponder()
        field.isEditable = false
        
        rowView?.isEditing = false
        
        isEditing = false
        
        (self.outlineView as? EditableOutlineView)?.isEditing = false
    }
    
    var rowView: EditableTableRowView? {
        if let rowView = self.superview as? EditableTableRowView {
            return rowView
        }
        
        return nil
    }
}

