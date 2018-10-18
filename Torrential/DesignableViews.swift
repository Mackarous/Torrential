//
//  DesignableViews.swift
//  Torrential
//
//  Created by Andrew Mackarous on 2018-10-18.
//  Copyright © 2018 Mackarous. All rights reserved.
//

import AppKit

@IBDesignable final class DesignableView: NSView { }

//extension NSView {
//    @IBInspectable public var cornerRadius: CGFloat {
//        get { return layer?.cornerRadius ?? 0 }
//        set { layer?.cornerRadius = newValue }
//    }
//    
//    @IBInspectable public var cornerRadius: CGFloat {
//        get { return layer?.cornerRadius ?? 0 }
//        set { layer?.cornerRadius = newValue }
//    }
//    
//    @IBInspectable public var borderColor: NSColor? {
//        get {
//            guard let cgColor = layer?.borderColor else { return nil }
//            return NSColor(cgColor: cgColor)
//        }
//        set { layer?.borderColor = newValue?.cgColor }
//    }
//    
//    @IBInspectable public var borderWidth: CGFloat {
//        get { return layer?.borderWidth ?? 0 }
//        set { layer?.borderWidth = newValue }
//    }
//    
//    @IBInspectable public var shadowColor: NSColor? {
//        get {
//            guard let cgColor = layer?.shadowColor else { return nil }
//            return NSColor(cgColor: cgColor)
//        }
//        set { layer?.shadowColor = newValue?.cgColor }
//    }
//    
//    @IBInspectable public var shadowOffset: CGSize {
//        get { return layer?.shadowOffset ?? .zero }
//        set { layer?.shadowOffset = newValue }
//    }
//    
//    @IBInspectable public var shadowRadius: CGFloat {
//        get { return layer?.shadowRadius ?? 0 }
//        set { layer?.shadowRadius = newValue }
//    }
//    
//    @IBInspectable public var shadowOpacity: Float {
//        get { return layer?.shadowOpacity ?? 0 }
//        set { layer?.shadowOpacity = newValue }
//    }
//}
