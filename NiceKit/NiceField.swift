//
//  NiceField.swift
//  Timelist
//
//  Created by Vojtech Rinik on 6/30/17.
//  Copyright © 2017 Vojtech Rinik. All rights reserved.
//

import Cocoa
import AppKit
import Cartography

fileprivate let text = NSColor(hexString: "36373B")!
fileprivate let lightText = NSColor(hexString: "ACB3BB")!

fileprivate let lightBorder = NSColor(hexString: "E6EBF0")!

open class NiceField: NSView, NSTextFieldDelegate {

    public let field = NSTextField()

    public let width = CGFloat(140.0)
    let marginSide = CGFloat(6.0)

    var widthConstraint: NSLayoutConstraint?

    public var stringValue: String {
        get {
            return field.stringValue
        }
        set {
            field.stringValue = newValue
        }
    }

    override public init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    open func setup() {
        layer = CALayer()
        wantsLayer = true

        layer?.actions = ["borderWidth": NSNull()]
        layer?.borderWidth = 0
        layer?.borderColor = lightBorder.cgColor
        layer?.cornerRadius = 3.0
        layer?.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        field.isBordered = false
        field.isSelectable = false
        field.isEditable = false
        field.backgroundColor = NSColor.clear
        //        field.drawsBackground = false
        field.stringValue = "No project"
        field.textColor = lightText
        field.focusRingType = .none
        field.setContentCompressionResistancePriority(.greatestFiniteMagnitude, for: .horizontal)

        field.delegate = self

        include(field, insets: NSEdgeInsets(top: 4.0, left: marginSide, bottom: 4.0, right: marginSide))

        constrain(self) { view in
            self.widthConstraint = (view.width == width)
        }

        widthConstraint?.isActive = false
    }

    var trackingArea: NSTrackingArea?

    override open func updateTrackingAreas() {
        if let area = trackingArea {
            removeTrackingArea(area)
        }

        trackingArea = NSTrackingArea(rect: bounds, options: [.mouseEnteredAndExited, .activeInKeyWindow], owner: self, userInfo: nil)
        self.addTrackingArea(trackingArea!)
    }

    override open func mouseEntered(with event: NSEvent) {
        layer?.borderWidth = 1
    }

    override open func mouseExited(with event: NSEvent) {
        layer?.borderWidth = 0
    }

    open func startEditing() {
        layer?.backgroundColor = lightBorder.cgColor

        field.isEditable = true
        field.textColor = text
        field.stringValue = ""

        widthConstraint?.isActive = true
        widthConstraint?.constant = width

        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.15
            context.allowsImplicitAnimation = true
            self.layoutSubtreeIfNeeded()
        }, completionHandler: nil)

        window?.makeFirstResponder(field)
    }

    override open func controlTextDidEndEditing(_ obj: Notification) {
        self.finishEditing()
    }

    open func finishEditing() {
        field.isEditable = false
        field.textColor = lightText

        let width = field.intrinsicContentSize.width + marginSide * 2
        widthConstraint?.constant = width


        layer?.backgroundColor = nil

        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.15
            context.allowsImplicitAnimation = true
            self.layoutSubtreeIfNeeded()
        }, completionHandler: nil)
    }

}

