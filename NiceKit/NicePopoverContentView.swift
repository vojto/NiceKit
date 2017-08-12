//
//  NicePopoverContentView.swift
//  NiceKit
//
//  Created by Vojtech Rinik on 6/16/17.
//  Copyright © 2017 Vojtech Rinik. All rights reserved.
//

import Foundation
import AppKit

public class NicePopoverContentView: NSView {
    override public init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }

    required public init?(coder: NSCoder) {
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
        layer?.backgroundColor = NSColor(hexString: "2B323B")!.cgColor
    }
}

