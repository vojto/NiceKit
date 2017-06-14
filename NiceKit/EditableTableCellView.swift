//
//  EditableTableCellView.swift
//  FocusPlan
//
//  Created by Vojtech Rinik on 4/26/17.
//  Copyright © 2017 Median. All rights reserved.
//

import Foundation
import AppKit

class EditableTableCellView: NSTableCellView, NSTextFieldDelegate {
    var node: NSTreeNode?
    var outlineView: NSOutlineView?
    var isEditing = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textField?.delegate = self
    }
    
    override func controlTextDidEndEditing(_ obj: Notification) {
        self.finishEditing()
    }
    
    override func controlTextDidChange(_ obj: Notification) {
    }
    
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if commandSelector == #selector(NSControl.cancelOperation(_:)) {
            window?.makeFirstResponder(nil)
            
            return true
        }
        
        return false
    }
    
    func startEditing() {
        guard let field = textField else { return }
        
        field.delegate = self
        
        field.isEditable = true
        window?.makeFirstResponder(field)
        
        rowView?.isEditing = true
        
        isEditing = true
    }
    
    func finishEditing() {
        guard let field = textField else { return }
        
        field.resignFirstResponder()
        field.isEditable = false
        
        rowView?.isEditing = false
        
        isEditing = false
    }
    
    var rowView: EditableTableRowView? {
        if let rowView = self.superview as? EditableTableRowView {
            return rowView
        }
        
        return nil
    }
}

