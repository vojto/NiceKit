//
//  NicePopoverTableRowView.swift
//  Timelist
//
//  Created by Vojtech Rinik on 6/20/17.
//  Copyright © 2017 Vojtech Rinik. All rights reserved.
//

import Cocoa
import Cartography

class NiceMenuTableRowView: NSTableRowView {
    
    let highlightView = NSView()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    func setup() {
        addSubview(highlightView)
        
        let sideMargin: CGFloat = 2.0
        
        constrain(highlightView) { view in
            view.top == view.superview!.top
            view.bottom == view.superview!.bottom
            view.left == view.superview!.left + sideMargin
            view.right == view.superview!.right - sideMargin
        }
        
        highlightView.layer = CALayer()
        highlightView.wantsLayer = true
        highlightView.layer?.cornerRadius = 3.0
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                highlightView.layer?.backgroundColor = NSColor("448EF3")!.cgColor
            } else {
                highlightView.layer?.backgroundColor = nil
            }
        }
    }
    
}
