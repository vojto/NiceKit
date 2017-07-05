//
//  NicePopover.swift
//  NiceKit
//
//  Created by Vojtech Rinik on 6/16/17.
//  Copyright © 2017 Vojtech Rinik. All rights reserved.
//

import Foundation
import AppKit

public class NicePopover: NSWindow {
    static var currentPopover: NicePopover?

    var viewController: NSViewController?
    var originFlipped = CGPoint(x: 0, y: 0)

    public convenience init() {
        let rect = NSRect(x: 100, y: 100, width: 200, height: 100)
        let styleMask: NSWindow.StyleMask = [.fullSizeContentView, .borderless]

        self.init(contentRect: rect, styleMask: styleMask, backing: .buffered, defer: false)

        self.isOpaque = false
        self.hasShadow = false
        self.backgroundColor = NSColor.clear

        let contentView = NicePopoverContentView()
        self.contentView = contentView

        self.animationBehavior = .utilityWindow

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleUpdateFrame(_:)),
            name: NSNotification.Name.NSViewFrameDidChange,
            object: contentView
        )
    }

    func handleUpdateFrame(_ notification: Notification) {
        self.updateOrigin()
    }

    public func show(viewController: NSViewController, parentWindow: NSWindow, view: NSView, edge: NSRectEdge, size: NSSize) {
        if let popover = NicePopover.currentPopover {
            popover.orderOut(self)
        }


        NicePopover.currentPopover = self

        self.viewController = viewController

        // Figure out the position based on view

        self.contentView?.removeSubviews()
        self.contentView?.include(viewController.view)

        let windowPosition = parentWindow.frame.origin
        let viewPosition = view.convert(NSPoint(x: 0, y: 0), to: nil)

        self.originFlipped = NSPoint(
            x: windowPosition.x + viewPosition.x,
            y: windowPosition.y + viewPosition.y
        )

        // Set the initial size
        var frame = self.frame
        frame.size = size
        self.setFrame(frame, display: true)

        updateOrigin()

        parentWindow.addChildWindow(self, ordered: .above)
        self.orderFront(self)
    }

    func updateOrigin() {
        let origin = NSPoint(
            x: originFlipped.x,
            y: originFlipped.y - frame.size.height
        )

        setFrameOrigin(origin)
    }

    public func hide() {
        orderOut(self)
    }
}

