//
//  NicePopoverContentView.swift
//  Timelist
//
//  Created by Vojtech Rinik on 6/16/17.
//  Copyright © 2017 Vojtech Rinik. All rights reserved.
//

import Foundation
import AppKit

class NicePopoverContentView: NSView {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        Swift.print("Setting up Popover's content view")
        
        self.layer = CALayer()
        self.wantsLayer = true
        
        layer?.cornerRadius = 4.0
        layer?.masksToBounds = true
//        layer?.backgroundColor = NSColor(calibratedWhite: 0, alpha: 0.8).cgColor
        layer?.backgroundColor = NSColor("2B323B")!.cgColor
    }
}
