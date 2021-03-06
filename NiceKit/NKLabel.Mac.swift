//
//  NKLabel.Mac.swift
//  FocusList
//
//  Created by Vojtech Rinik on 12/02/16.
//  Copyright © 2016 Vojtech Rinik. All rights reserved.
//

import Foundation

open class NKLabel: NKTextField {
    open var userInteractionEnabled = true

    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        self.drawsBackground = false
        self.isEditable = false
        self.isSelectable = false
        self.isBezeled = false
        self.lineBreakMode = .byWordWrapping
        self.setContentCompressionResistancePriority(NSLayoutConstraint.Priority(rawValue: 250), for: .horizontal)
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public convenience init(text: String) {
        self.init(frame: CGRect.zero)

        self.text = text
    }
}
