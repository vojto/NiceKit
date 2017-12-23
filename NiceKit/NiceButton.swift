//
//  NiceButton.swift
//  NiceKit
//
//  Created by Vojtech Rinik on 6/14/17.
//  Copyright © 2017 Vojtech Rinik. All rights reserved.
//

import AppKit
import Cartography

public class NiceButton: NSView {
    public var image: NSImage? {
        didSet { update() }
    }
    public var title: String? {
        didSet { update() }
    }
    public var color = NSColor.labelColor {
        didSet { update() }
    }
    public var font = NSFont.systemFont(ofSize: 13) {
        didSet {
            label.font = self.font
        }
    }

    public var onClick: (() -> ())?

    let stackView = NSStackView()
    let imageView = NSImageView()
    let label = NSTextField()

    public init(title: String, image: NSImage) {
        super.init(frame: NSZeroRect)

        self.image = image
        self.title = title

        setup()
    }

    override public init(frame frameRect: NSRect) {
        fatalError("call init(title:image:)")
    }

    required public init?(coder: NSCoder) {
        fatalError("call init(title:image:)")
    }


    func setup() {
        self.include(stackView, insets: NSEdgeInsets(top: 4.0, left: 8.0, bottom: 4.0, right: 8.0))

        self.wantsLayer = true
        self.layer = CALayer()

        layer?.actions = ["borderWidth": NSNull()]
        layer?.borderWidth = 0
        layer?.borderColor = NiceColors.lightBorder.cgColor
        layer?.cornerRadius = 3.0
        layer?.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        imageView.imageScaling = .scaleNone

        label.isBordered = false
        label.drawsBackground = false
        label.isEditable = false
        label.isSelectable = false

        stackView.orientation = .horizontal
        stackView.spacing = 6.0
        stackView.alignment = .centerY
        stackView.setViews([imageView, label], in: .center)

        update()
    }

    func update() {
        if let image = self.image {
            self.imageView.image = image.tintedImageWithColor(color: color)
        }

        if let title = self.title {
            self.label.stringValue = title
        }

        label.textColor = color
    }

    // Tracking area

    var trackingArea: NSTrackingArea?

    override open func updateTrackingAreas() {
        if let area = trackingArea {
            removeTrackingArea(area)
        }

        trackingArea = NSTrackingArea(rect: bounds, options: [NSTrackingArea.Options.mouseEnteredAndExited, NSTrackingArea.Options.activeInKeyWindow], owner: self, userInfo: nil)
        self.addTrackingArea(trackingArea!)
    }

    override public func mouseEntered(with event: NSEvent) {
        layer?.borderWidth = 1
    }

    override public func mouseExited(with event: NSEvent) {
        layer?.borderWidth = 0
    }

    override public func mouseDown(with event: NSEvent) {
        layer?.backgroundColor = NiceColors.lightBorder.cgColor
        layer?.transform = CATransform3DMakeScale(0.95, 0.95, 1)

        super.mouseDown(with: event)
    }

    override public func mouseUp(with event: NSEvent) {
        layer?.backgroundColor = nil
        layer?.transform = CATransform3DIdentity

        onClick?()

        super.mouseUp(with: event)
    }
}

