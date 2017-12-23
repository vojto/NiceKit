//
//  NSApplication+Additions.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 15/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation
import Cocoa

public extension XApplication {
    class func hideDockIcon() {
        self.setDockIconVisible(false)
    }
    
    class func showDockIcon() {
        self.setDockIconVisible(true)
    }
    
    // Taken from: http://stackoverflow.com/a/26284141/304321
    
    @discardableResult class func setDockIconVisible(_ state: Bool) -> Bool {
        var result: Bool
        if state {
            result = NSApp.setActivationPolicy(NSApplication.ActivationPolicy.regular)
        } else {
            result = NSApp.setActivationPolicy(NSApplication.ActivationPolicy.accessory)
        }
        
        NSApp.presentationOptions = NSApplication.PresentationOptions()
        
        NSMenu.setMenuBarVisible(false)
        NSMenu.setMenuBarVisible(true)
        
        NSApplication.shared.activate(ignoringOtherApps: true)

        // SWIFT3-TODO
//        Timer.schedule(delay: 0.1) { _ in
//            self.show()
//        }
        
        return result
    }
    
    class func show() {
        // TODO: Use storybard here or something


//        NSApp.activateIgnoringOtherApps(true)
//        if let window = (NSApp!.delegate as! NSObject).valueForKey("window") as? NSWindow {
//            window.makeKeyAndOrderFront(nil)
//        }
    }
    
    // Taken from: https://github.com/keith/LoginItemTest
    public class func launchMainAppFromHelperApp() {
        print("Launching")

        let bundlePath = (Bundle.main.bundlePath as NSString)

        print("bundle path: \(bundlePath)")
        
        let workspace = NSWorkspace.shared
        
        let identifier = "rinik.Escape"
        
        if let url = workspace.urlForApplication(withBundleIdentifier: identifier) {
            var config = [NSWorkspace.LaunchConfigurationKey: AnyObject]()
            config[.arguments] = ["quiet", "test"] as NSArray
            config[.environment] = ["quiet": "true"] as NSDictionary
            

            do {
                try workspace.launchApplication(at: url, options: [NSWorkspace.LaunchOptions.default], configuration: config)
            } catch _ {
                Swift.print("Failed launching app with config: \(config)")
            }
        } else {
            Swift.print("Couldn't find application with identifier \(identifier)")
        }
        
    }

    var applicationState: XApplicationState {
        return .active
    }

}
