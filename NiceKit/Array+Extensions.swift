//
//  Array+Extensions.swift
//  NiceKit
//
//  Created by Vojtech Rinik on 4/26/17.
//  Copyright © 2017 Median. All rights reserved.
//

import Foundation

public extension Array {
    public func at(_ index: Int) -> Element? {
        if index < count {
            return self[index]
        } else {
            return nil
        }
    }
    
    public func sub(from: Int, to: Int) -> [Element] {
        if count == 0 {
            return self
        }
        let to = Swift.min(to, count - 1)
        return Array(self[from...to])
    }
    
    public func moving(from: Int, to: Int) -> [Element] {
        var copy = self
        let item = copy.remove(at: from)
        copy.insert(item, at: to)
        
        return copy
    }
    
}
