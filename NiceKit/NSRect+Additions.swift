//
//  NSRect+Additions.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 07/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation

//func NSRectMidPoint(rect: CGRect) -> CGPoint {
//    return NSMakePoint(NSMidX(rect), NSMidY(rect))
//}
extension NSRect {
    
}

public func *(lhs: CGRect, rhs: CGFloat) -> CGRect {
    var frame = lhs
    
    frame.size.width *= rhs
    frame.size.height *= rhs
    frame.origin.x *= rhs
    frame.origin.y *= rhs
    
    return frame
}

public func +(lhs: CGRect, rhs: CGPoint) -> CGRect {
    var frame = lhs
    
    frame.origin.x += rhs.x
    frame.origin.y += rhs.y
    
    return frame
}
