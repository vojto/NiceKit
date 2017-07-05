//
//  NicePopoverTableRowView.swift
//  NiceKit
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


        let layer = CALayer()
        layer.cornerRadius = 3.0
        layer.actions = [
            "backgroundColor": NSNull()
        ]

        highlightView.layer = layer
        highlightView.wantsLayer = true

    }

    override var isSelected: Bool {
        didSet {
            if isSelected {
                highlightView.layer?.backgroundColor = NSColor(hexString: "448EF3")!.cgColor
            } else {
                highlightView.layer?.backgroundColor = nil
            }
        }
    }

}

