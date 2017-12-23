//
//  NKView+Layout.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 16/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation
import Cartography

public extension NKViewable {
    public func setup() {
        
    }

    @discardableResult public func expandX() -> ConstraintGroup {
        return constrain(self as! XView) { v in
            v.left == v.superview!.left
            v.right == v.superview!.right
        }
    }

    @discardableResult public func expandY() -> ConstraintGroup {
        return constrain(self as! XView) { v in
            v.top == v.superview!.top
            v.bottom == v.superview!.bottom
        }
    }

    @discardableResult public func expandX(_ left: CGFloat, right: CGFloat) -> ConstraintGroup {
        return constrain(self as! XView) { v in
            v.left == v.superview!.left + left
            v.right == v.superview!.right - right
        }
    }

    @discardableResult public func centerX() -> ConstraintGroup {
        return constrain(self as! XView) { v in
            v.centerX == v.superview!.centerX
        }
    }

    @discardableResult public func centerY() -> ConstraintGroup {
        return constrain(self as! XView) { v in
            v.centerY == v.superview!.centerY
        }
    }
}

extension XView {
    // MARK: Layout
    
    public func setWidth(_ width: CGFloat) {
        constrain(self) { view in
            view.width == width
        }
    }
    
    public func setHeight(_ height: CGFloat) {
        constrain(self) { view in
            view.height == height
        }
    }
    
    public func setSize(_ width: CGFloat, height: CGFloat) {
        self.setWidth(width)
        self.setHeight(height)
    }
    
    @discardableResult public func expand() -> ConstraintGroup {
        return self.expand(NKPadding(top: 0, right: 0, bottom: 0, left: 0))
    }
    
    public func expand(_ padding: NKPadding) -> ConstraintGroup {
        return expand(padding, priority: 1000)
    }

    public func expand(_ padding: NKPadding, priority: Float) -> ConstraintGroup {
        return constrain(self) { v in
            v.bottom == v.superview!.bottom - padding.bottom ~ priority
            v.left == v.superview!.left + padding.left ~ priority
            v.top == v.superview!.top + padding.top ~ priority
            v.right == v.superview!.right - padding.right ~ priority
        }
    }

//    func expandX() ->  ConstraintGroup {
//        return constrain(self) { v in
//            v.left == v.superview!.left
//            v.right == v.superview!.right
//        }
//    }

    public func expandBottom() -> ConstraintGroup {
        return constrain(self) { v in
            v.bottom == v.superview!.bottom
            v.left == v.superview!.left
            v.right == v.superview!.right
        }
    }
    
    public func center() -> ConstraintGroup {
        return constrain(self) { v in
            v.centerX == v.superview!.centerX
            v.centerY == v.superview!.centerY
        }
    }



    public func centerY() -> ConstraintGroup {
        return constrain(self) { v in
            v.centerY == v.superview!.centerY
        }
    }
}



public extension NSView {
    func removeSubviews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
}

public enum StackDirection {
    case column
    case row
}

//public extension LayoutProxy {
//    public func start(_ direction: StackDirection) -> Edge {
//        switch direction {
//        case .column:
//            return left
//        case .row:
//            return top
//        }
//    }
//
//    public func end(_ direction: StackDirection) -> Edge {
//        switch direction {
//        case .column:
//            return right
//        case .row:
//            return bottom
//        }
//    }
//
//    public func edge(type: EdgeType) -> Edge {
//        switch type {
//        case .top:
//            return top
//        case .bottom:
//            return bottom
//        case .left:
//            return left
//        case .right:
//            return right
//        case .centerX:
//            return centerX
//        case .centerY:
//            return centerY
//        }
//    }
//}

public func alignEdges(_ direction: StackDirection, _ align: StackAlign) -> [EdgeType] {
    switch direction {
    case .column:
        switch align {
        case .start:
            return [.top]
        case .center:
            return [.centerY]
        case .end:
            return [.bottom]
        case .stretch:
            return [.top, .bottom]
        }
    case .row:
        switch align {
        case .start:
            return [.left]
        case .center:
            return [.centerX]
        case .end:
            return [.right]
        case .stretch:
            return [.left, .right]
        }
    }
}



public enum EdgeType {
    case top
    case centerY
    case centerX
    case bottom
    case left
    case right
}

public enum StackAlign {
    case start
    case center
    case end
    case stretch
}

public extension Array where Element:NSView {
//    public func stack(_ dir: StackDirection, margin: CGFloat = 0, align: StackAlign = .center) -> NSView {
//        let container = NSView()
//
//        for view in self {
//            container.addSubview(view)
//        }
//
//        // Align all children
//        for view in self {
//            constrain(view) { view in
//                for edgeType in alignEdges(dir, align) {
//                    view.edge(type: edgeType) == view.superview!.edge(type: edgeType)
//                }
//            }
//        }
//
//        constrain(self.first!) { view in
//            view.start(dir) == view.superview!.start(dir)
//        }
//
//        for i in 1..<self.count {
//            constrain(self[i], self[i-1]) { current, previous in
//                current.start(dir) == previous.end(dir) + margin
//            }
//        }
//
//        constrain(self.last!) { view in
//            view.end(dir) == view.superview!.end(dir) ~ 250
//        }
//
//        return container
//    }
    
    public func equalWidths() {
        for i in 1...(self.count - 1) {
            constrain(self[i], self[i - 1]) { current, previous in
                current.width == previous.width
            }
        }
    }
    
    public func equalHeights() {
        for i in 1...(self.count - 1) {
            constrain(self[i], self[i - 1]) { current, previous in
                current.height == previous.height
            }
        }
    }
}

public extension NSView {
    @discardableResult public func append(_ view: NSView, left: CGFloat = 0, top: CGFloat = 0) -> NSView {
        addSubview(view)
        
        constrain(view) { view in
            view.left == view.superview!.left + left
            view.top == view.superview!.top + top
        }
        
        return view
    }
    
    @discardableResult public func include(_ view: NSView, inset ins: CGFloat = 0) -> NSView {
        addSubview(view)
        
        constrain(view) { view in
            view.edges == inset(view.superview!.edges, ins, ins, ins, ins)
        }
        
        return view
    }
    
    @discardableResult public func include(_ view: NSView, insets ins: NSEdgeInsets) -> NSView {
        addSubview(view)
        
        constrain(view) { view in
            view.edges == inset(view.superview!.edges, ins.top, ins.left, ins.bottom, ins.right)
        }
        
        return view
    }
    
    @discardableResult public func height(_ height: CGFloat) -> NSView {
        constrain(self) { view in
            view.height == height
        }
        
        return self
    }
    
    @discardableResult public func width(_ width: CGFloat) -> NSView {
        constrain(self) { view in
            view.width == width
        }
        
        return self
    }
    
//    @discardableResult public func expand(_ dir: StackDirection) -> NSView {
//        constrain(self) { view in
//            view.start(dir) == view.superview!.start(dir)
//            view.end(dir) == view.superview!.end(dir)
//        }
//        
//        return self
//    }
}
