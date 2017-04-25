//
//  NKButton.swift
//  Median
//
//  Created by Vojtech Rinik on 30/09/2016.
//  Copyright © 2016 Vojtech Rinik. All rights reserved.
//

import Foundation

open class NKButton: NSButton {
    open var onClick: ((NSEvent) -> ())?
    
    override public init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    override open func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
        // This is not really called, dunno why...
    }
    
    override open func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        onClick?(event)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
