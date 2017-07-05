//
//  NiceField.swift
//  NiceKit
//
//  Created by Vojtech Rinik on 6/30/17.
//  Copyright © 2017 Vojtech Rinik. All rights reserved.
//

import Cocoa
import AppKit
import Cartography


open class NiceField: NSView, NSTextFieldDelegate {

    public let field = NSTextField()
    public var textColor = NiceColors.lightText { didSet { updateStyle() }}
    public var borderColor = NiceColors.lightBorder { didSet { updateStyle() }}
    public var editingBackgroundColor = NiceColors.lightBorder { didSet { updateStyle() }}

    open var width: CGFloat {
        return 80.0
    }
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

    public var onChange: ((String) -> ())?

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
        layer?.borderColor = borderColor.cgColor
        layer?.cornerRadius = 3.0
        layer?.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        field.isBordered = false
        field.isSelectable = false
        field.isEditable = false
        field.backgroundColor = NSColor.clear
        field.font = NSFont.systemFont(ofSize: 12)
        //        field.drawsBackground = false
        field.stringValue = "wtf"
        field.focusRingType = .none
        field.setContentCompressionResistancePriority(.greatestFiniteMagnitude, for: .horizontal)

        field.delegate = self

        include(field, insets: NSEdgeInsets(top: 4.0, left: marginSide, bottom: 4.0, right: marginSide))

        constrain(self) { view in
            self.widthConstraint = (view.width == width)
        }

        widthConstraint?.isActive = false
    }

    func updateStyle() {
        field.textColor = self.textColor
        layer?.borderColor = self.borderColor.cgColor
    }

    var trackingArea: NSTrackingArea?

    override open func updateTrackingAreas() {
        if let area = trackingArea {
            removeTrackingArea(area)
        }

        trackingArea = NSTrackingArea(rect: bounds, options: [.mouseEnteredAndExited, .activeInKeyWindow], owner: self, userInfo: nil)
        self.addTrackingArea(trackingArea!)
    }

    var isEditing: Bool = false

    override open func mouseEntered(with event: NSEvent) {
        if !isEditing {
            layer?.borderWidth = 1
        }
    }

    override open func mouseExited(with event: NSEvent) {
        layer?.borderWidth = 0
    }

    override open func mouseDown(with event: NSEvent) {
        startEditing()
    }

    open func startEditing() {
        layer?.backgroundColor = self.editingBackgroundColor.cgColor
        layer?.borderWidth = 0

        field.isEditable = true
        field.textColor = self.textColor

        widthConstraint?.isActive = true
        widthConstraint?.constant = width

        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.15
            context.allowsImplicitAnimation = true
            self.layoutSubtreeIfNeeded()
        }, completionHandler: nil)

        window?.makeFirstResponder(field)

        isEditing = true

        field.currentEditor()?.moveToEndOfLine(nil)
    }

    override open func controlTextDidEndEditing(_ obj: Notification) {
        self.finishEditing()
    }

    
    open func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {

        if commandSelector == #selector(NSResponder.insertNewline(_:)) {
            self.finishEditing()
            return true
        } else if commandSelector == #selector(NSResponder.cancelOperation(_:)) {
            self.finishEditing()
            return true
        } else if commandSelector == #selector(NSResponder.insertTab(_:)) {
            self.finishEditing()
            return true
        }

        return false
    }

    open func finishEditing() {
        window?.makeFirstResponder(nil)

        field.isEditable = false
        field.isSelectable = false
        field.textColor = self.textColor

        let width = field.intrinsicContentSize.width + marginSide * 2
        widthConstraint?.constant = width

        layer?.backgroundColor = nil

        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.15
            context.allowsImplicitAnimation = true
            self.layoutSubtreeIfNeeded()

            self.onChange?(field.stringValue)
        }, completionHandler: nil)

        isEditing = false
    }

}

