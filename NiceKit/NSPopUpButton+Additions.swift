//
//  NSPopUpButton+Additions.swift
//  Median
//
//  Created by Vojtech Rinik on 28/09/2016.
//  Copyright © 2016 Vojtech Rinik. All rights reserved.
//

import Foundation
import AppKit

extension NSPopUpButton {
    public var items: [String] {
        get {
            return itemTitles
        }
        
        set {
            removeAllItems()
            
            for item in newValue.map({ $0 }) {
                addItem(withTitle: item)
            }
        }
    }
}

open class NKPopUpButton: NSPopUpButton {
    open var onChange: ((Int) -> ())?
    
    convenience public init() {
        self.init(frame: NSZeroRect, pullsDown: false)
    }
    
    override public init(frame: NSRect, pullsDown: Bool) {
        super.init(frame: frame, pullsDown: pullsDown)
        
        self.setup()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setup()
    }
    
    func setup() {
        self.target = self
        self.action = #selector(handleChange)
    }
    
    @objc func handleChange() {
        Swift.print("Handling change in NKPopupButton")
        
        self.onChange?(indexOfSelectedItem)
    }
}


    
