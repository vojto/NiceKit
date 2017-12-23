//
//  NKWindow.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 03/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Cocoa

public enum NKWindowOpeningPolicy: String {
    case Default
    case Sheet
}

extension NSWindow {
    public func presentSheet(_ view: NSView, size: CGSize) {
        if attachedSheet != nil {
            return
        }
        
    
        let window = NKSheetWindow(contentRect: CGRect(x: 0, y: 0, width: size.width, height: size.height), styleMask: NSWindow.StyleMask.titled, backing: .buffered, defer: false)

        
        window.contentView = view
        
        beginSheet(window) { _ in
        }
    }
    
    
    public func present(viewController: NSViewController, size: CGSize) {
        if attachedSheet != nil {
            return
        }
        
        let window = NKSheetWindow(contentRect: CGRect(x: 0, y: 0, width: size.width, height: size.height), styleMask: NSWindow.StyleMask.titled, backing: .buffered, defer: false)
        
        window.contentViewController = viewController
        
        beginSheet(window) { _ in
        }
    }
    
    
    
    public func closeSheet() {
        if let sheet = attachedSheet {
            endSheet(sheet)
        }
    }

}

class NKSheetWindow: NSWindow {
//    var parentWindow: NKWindow?
//    @IBAction func paste(_ sender: AnyObject?) {
//        Swift.print("Pasting in NKWindow")
//    }
    
}


