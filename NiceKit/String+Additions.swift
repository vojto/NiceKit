//
//  String+Additions.swift
//  Median
//
//  Created by Vojtech Rinik on 06/10/2016.
//  Copyright © 2016 Vojtech Rinik. All rights reserved.
//

import Foundation

public extension String {
    func substr(_ startIndex: Int, _ length: Int) -> String {
        let start = self.characters.index(self.startIndex, offsetBy: startIndex)
        let end = self.characters.index(self.startIndex, offsetBy: startIndex + length)
        return self.substring(with: (start ..< end))
    }
    
    func substr(start: Int, end: Int) -> String {
        return self.substr(start, end - start)
    }
    
    var range: NSRange {
        return NSRange(location: 0, length: (self as NSString).length)
    }
    
    public var length: Int {
        return (self as NSString).length
    }
    
    func indexOf(substring: String) -> Int? {
        if let index = self.range(of: "<")?.lowerBound {
            return self.distance(from: self.startIndex, to: index)
        }
        
        return nil
    }
}
