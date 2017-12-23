//
//  NSAttributedString+Additions.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 04/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation
#if os(OSX)
import AppKit
#endif

public extension NSMutableAttributedString {
    func addAttribute(_ name: String, value: Any) {
        self.addAttribute(NSAttributedStringKey(rawValue: name), value: value, range: NSMakeRange(0, self.length))
    }
    
    func attributeValue(_ name: String) -> Any? {
        var range = NSMakeRange(0, self.length)
        return self.attribute(NSAttributedStringKey(rawValue: name), at: 0, effectiveRange: &range) as Any?
    }
    
    func removeAttribute(_ name: String) {
        self.removeAttribute(NSAttributedStringKey(rawValue: name), range: NSMakeRange(0, self.length))
    }
    
    func replaceAttribute(_ name: String, newValue: Any?) {
        self.removeAttribute(name)
        if let value = newValue {
            self.addAttribute(name, value: value)
        }
    }

    var attributes: [String: Any] {
        let range = NSMakeRange(0, self.length)
        var attrs = [String: Any]()
        
        fatalError("broken")
        
        self.enumerateAttributes(in: range, options: NSAttributedString.EnumerationOptions()) { (dct, range, wtf) in
            
//            for (key, value) in dct {
//                attrs[key] = value
//            }
        }
        
        return attrs
    }
    
    public var textColor: XColor? {
        get {
            return self.attributeValue(XForegroundColorAttributeName.rawValue) as? NSColor
        }
        set {
            self.replaceAttribute(XForegroundColorAttributeName.rawValue, newValue: newValue)
        }
    }
    
    public var font: XFont? {
        get {
            return self.attributeValue(XFontAttributeName.rawValue) as? XFont
        }
        set {
            self.replaceAttribute(XFontAttributeName.rawValue, newValue: newValue)
        }
    }
    
    public var strikethroughStyle: Int? {
        get {
            return self.attributeValue(XStrikethroughStyleAttributeName.rawValue) as? Int
        }
        set {
            self.replaceAttribute(XStrikethroughStyleAttributeName.rawValue, newValue: newValue as Any?)
        }
    }

    #if os(OSX)
    public var style: NSParagraphStyle? {
        get { return self.attributeValue(NSAttributedStringKey.paragraphStyle.rawValue) as? NSParagraphStyle }
        set {
            self.replaceAttribute(NSAttributedStringKey.paragraphStyle.rawValue, newValue: newValue)
        }
    }
    #endif
}

public func +=(lhs: NSMutableAttributedString, rhs: NSAttributedString) {
    lhs.append(rhs)
}

public func +=(lhs: NSMutableAttributedString, rhs: String) {
    lhs.append(NSAttributedString(string: rhs))
}

public func +(lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
    let str1 = lhs.mutableCopy() as! NSMutableAttributedString
    str1.append(rhs)
    return str1
}

public func +(lhs: String, rhs: NSAttributedString) -> NSMutableAttributedString {
    let str = NSMutableAttributedString(string: lhs)
    str.append(rhs)
    return str
}
