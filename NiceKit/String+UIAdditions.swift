//
//  NSString+Additions.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 07/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation
import CoreGraphics

public extension String {
    func calculateHeight(_ font: XFont, width: CGFloat, padding: NKPadding) -> CGFloat {
        let attributed = NSAttributedString(string: self)
        return attributed.calculateHeight(font, width: width, padding: padding)
    }
    
    func calculateWidth(fontSize: CGFloat) -> CGFloat {
        let font = NSFont.systemFont(ofSize: fontSize)
        return self.calculateWidth(font: font)
    }
    
    func calculateWidth(font: NSFont) -> CGFloat {
        let attr = NSMutableAttributedString(string: self)
        attr.font = font
        let size = attr.boundingRect(with: CGSize(width: 99999, height: 50), options: NSString.DrawingOptions.usesLineFragmentOrigin)
        return size.width
    }
}

extension NSAttributedString {
    func calculateHeight(_ font: XFont, width: CGFloat) -> CGFloat {
        let attributedString = self.mutableCopy() as! NSMutableAttributedString
        attributedString.font = font

        let bounds = CGSize(width: width, height: 10000)

        #if os(OSX)
        let size = attributedString.boundingRect(with: bounds, options: NSString.DrawingOptions.usesLineFragmentOrigin)
        #else
        let size = attributedString.boundingRectWithSize(bounds, options: [.UsesLineFragmentOrigin, .UsesFontLeading], context: nil)
        #endif

        return ceil(size.height)
    }
    
    func calculateHeight(_ font: XFont, width: CGFloat, padding: NKPadding) -> CGFloat {
        return self.calculateHeight(font, width: width - padding.horizontal) + padding.vertical
    }
}
