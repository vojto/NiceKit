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
    public var style = Style.hud {
        didSet {
            (contentView as! NicePopoverContentView).style = style
            updateStyle()
        }
    }

    public enum Style {
        case normal
        case hud
    }

    public enum Side {
        case below
        case center
    }

    public convenience init() {
        let rect = NSRect(x: 100, y: 100, width: 200, height: 100)
        let styleMask: NSWindow.StyleMask = [NSWindow.StyleMask.fullSizeContentView, NSWindow.StyleMask.borderless]

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
            name: NSView.frameDidChangeNotification,
            object: contentView
        )
    }

    @objc func handleUpdateFrame(_ notification: Notification) {
        self.updateOrigin()
    }

    func updateStyle() {
        switch style {
        case .normal:
            self.hasShadow = true
        case .hud:
            self.hasShadow = false

        }
    }

    public func show(viewController: NSViewController, parentWindow: NSWindow, view: NSView, side: Side, size: NSSize) {
        if let popover = NicePopover.currentPopover {
            popover.orderOut(self)
        }


        NicePopover.currentPopover = self

        self.viewController = viewController

        // Figure out the position based on view

        self.contentView?.removeSubviews()
        self.contentView?.include(viewController.view)

        let windowPosition = parentWindow.frame.origin
        let windowSize = parentWindow.frame.size
        let viewPosition = view.convert(NSPoint(x: 0, y: 0), to: nil)

        switch side {
        case .below:
            self.originFlipped = NSPoint(
                x: windowPosition.x + viewPosition.x,
                y: windowPosition.y + viewPosition.y
            )
        case .center:
            self.originFlipped = NSPoint(
                x: windowPosition.x + (windowSize.width - size.width) / 2,
                y: windowPosition.y + (windowSize.height) / 2 + size.height
            )

        }


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

