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
    var style = NicePopover.Style.hud {
        didSet { updateStyle() }
    }

    override public init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    func setup() {
        self.layer = CALayer()
        self.wantsLayer = true

        updateStyle()
    }

    func updateStyle() {
        layer?.cornerRadius = 4.0
        layer?.masksToBounds = true

        switch style {
        case .normal:
            layer?.backgroundColor = NSColor(hexString: "ffffff")!.cgColor
        case .hud:
            layer?.backgroundColor = NSColor(hexString: "2B323B")!.cgColor
        }

    }
}

