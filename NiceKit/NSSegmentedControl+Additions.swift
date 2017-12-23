//
//  NSSegmentedControl+.swift
//  Median
//
//  Created by Vojtech Rinik on 27/09/2016.
//  Copyright © 2016 Vojtech Rinik. All rights reserved.
//

import Foundation
import AppKit

public extension NSSegmentedControl {
    public var labels: [String] {
        get {
            var labels = [String]()
            for i in 0..<segmentCount {
                labels.append(self.label(forSegment: i)!)
            }
            return labels
        }
        
        set {
            self.segmentCount = newValue.count
            for (i, label) in newValue.enumerated() {
                setLabel(label, forSegment: i)
            }
        }
    }
}

open class NKSegmentedControl: NSSegmentedControl {
    open var onChange: ((Int) -> ())?
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        self.target = self
        self.action = #selector(handleChange)
    }
    
    @objc func handleChange() {
        self.onChange?(selectedSegment)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
