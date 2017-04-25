//
//  NSOutlineView+Extensions.swift
//  NiceKit
//
//  Created by Vojtech Rinik on 4/25/17.
//  Copyright © 2017 Median. All rights reserved.
//

import Foundation

public extension NSOutlineView {
    public func select(row: Int) {
        var row = row
        let total = numberOfRows
        
        if row >= numberOfRows {
            row = total - 1
        }
        
        selectRowIndexes(IndexSet([row]), byExtendingSelection: false)
    }
}
