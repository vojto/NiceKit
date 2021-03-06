//
//  NKTextField.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 07/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation
import Cocoa
import CoreGraphics



public enum NKAutocorrectionType {
    case no
}

public enum NKAutocapitalizationType {
    case none
}

public enum NKKeyboardType {
    case numberPad
}


open class NKTextField: NSTextField, NKViewable {
    var transientDelegate: NKTextFieldDelegate

    open var style: NKStyle
    open var placeholderStyle: NKStyle
    open var classes = Set<String>()

    open var onChange: NKSimpleCallback?
    open var onCancel: NKSimpleCallback?
    open var onBlur: NKSimpleCallback?
    open var onFocus: NKSimpleCallback?
    open var onSubmit: NKSimpleCallback?
    open var onTab: NKSimpleCallback?

    open var onAction: NKSimpleCallback? {
        get { return onClick }
        set { onClick = newValue }
    }

    open var onClick: NKSimpleCallback?
    open var onMouseDown: ((NSEvent) -> Void)?
    open var onMouseUp: ((NSEvent) -> Void)?

    open var autocorrectionType: NKAutocorrectionType?
    open var autocapitalizationType: NKAutocapitalizationType?
    open var keyboardType: NKKeyboardType?

    open var fieldType: NKFieldType?
    open var secureValue: String = ""

    open override var placeholder: String? {
        get { return super.placeholder }
        set {
            let str = NSMutableAttributedString(string: newValue!)
            str.font = placeholderStyle.font
            str.textColor = placeholderStyle.textColor?.color
            super.placeholderAttributedString = str
        }
    }

//    override var text: String? {
//        get { return super.text }
//        set {
//            super.text = newValue
//            applyStyle()
//        }
//    }

    // MARK: - Lifecycle
    // ----------------------------------------------------------------------

    public override init(frame frameRect: NSRect) {
        self.style = NKStylesheet.styleForView(type(of: self))
        self.placeholderStyle = NKStylesheet.styleForView(type(of: self), classes: ["placeholder"])

        self.transientDelegate = NKTextFieldDelegate()
        
        super.init(frame: frameRect)
        
        self.delegate = self.transientDelegate
        
        self.transientDelegate.textField = self

//        self.drawsBackground = false
//        self.backgroundColor = XColor.clear
//        self.isBordered = false
//        self.focusRingType = .none

        // applyStyle()
    }

    open func setup() {
    }

    public convenience init(placeholder: String) {
        self.init(frame: CGRect.zero)

        self.placeholder = placeholder
    }

    required public init?(coder: NSCoder) {
        self.transientDelegate = NKTextFieldDelegate()
        self.style = NKStylesheet.styleForView(type(of: self))
        self.placeholderStyle = NKStylesheet.styleForView(type(of: self), classes: ["placeholder"])
        
        super.init(coder: coder)
        
        self.delegate = self.transientDelegate
        self.transientDelegate.textField = self
    }


    // MARK: - Style support
    // ----------------------------------------------------------------------

    open func applyStyle() {
        font = style.font

        if let color = style.textColor {
            self.textColor = color.color
        }

        if let opacity = style.opacity {
            self.alpha = opacity
        } else {
            self.alpha = 1
        }

        if let align = style.textAlign {
            switch(align) {
            case .Left: textAlignment = .left
            case .Center: textAlignment = .center
            case .Right: textAlignment = .right
            }
        }

        if let background = style.background {
            self.backgroundColor = background.color
            self.drawsBackground = true
        }

//        let text = style.prepareAttributedString(self.text!)
//        self.attributedStringValue = text
    }


    // MARK: - Events
    // ----------------------------------------------------------------------
    
    open func handleClickFromTable(_ event: NSEvent) {
        if self.isEditable {
            self.window?.makeFirstResponder(self)
        }
    }

    override open func textDidEndEditing(_ notification: Notification) {
        super.textDidEndEditing(notification)
        onBlur?()
    }

    override open func textDidBeginEditing(_ notification: Notification) {
        super.textDidBeginEditing(notification)
        onFocus?()
    }

    open func blur() {
        window?.makeFirstResponder(nil)
    }

    open func focus() {
        window?.makeFirstResponder(self)
    }

    var hasClickHandler: Bool {
        return onMouseDown != nil || onMouseUp != nil || onClick != nil
    }

    open override func mouseDown(with theEvent: NSEvent) {
        super.mouseDown(with: theEvent)
        onMouseDown?(theEvent)
    }

    open override func mouseUp(with theEvent: NSEvent) {
        super.mouseUp(with: theEvent)
        onMouseUp?(theEvent)
        onClick?()
    }
    
    open func triggerChange() {
        self.onChange?()
    }

    var lastValue: String = ""

    open override var stringValue: String {
        get {
            return super.stringValue
        }
        set {
            self.lastValue = newValue
            super.stringValue = newValue
        }
    }

}

class NKTextFieldDelegate: NSObject, NSTextFieldDelegate {
    var textField: NKTextField!

    override func controlTextDidChange(_ notification: Notification) {
        textField.triggerChange()
    }


    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        
        if let onTab = textField.onTab, String(describing: commandSelector) == "insertTab:" {
            onTab()
            return true
        } else if String(describing: commandSelector) == "cancelOperation:" {
            textField.onCancel?()
            return true
        } else if String(describing: commandSelector) == "insertNewline:" {
            textField.onSubmit?()
            return true
        }

        return false
    }
}
