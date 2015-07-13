//
//  TPWindow.swift
//  Tempest
//
//  Created by Cyril Hou on 15/4/19.
//  Copyright (c) 2015年 Cyrilis.com. All rights reserved.
//

import Foundation
import Cocoa

class TPWindow: NSWindow {


    var cannotDrag:Bool = false
    var initialLocation:NSPoint
    override var canBecomeKeyWindow :Bool {return true}
    override var canBecomeMainWindow :Bool {return true}
    var childWebView:TPWebView?
    var parentWebView:TPWebView?
    
    override init(contentRect: NSRect, styleMask aStyle: Int, backing bufferingType: NSBackingStoreType, `defer` flag: Bool) {
        self.initialLocation = NSPoint(x: 0, y: 0)
        super.init(contentRect: contentRect, styleMask: aStyle, backing: bufferingType, `defer`: flag)
        self.opaque = false
        self.movableByWindowBackground = true
        self.hasShadow = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sendEvent(theEvent: NSEvent) {
        if self.cannotDrag {
        //  `print` function cause printer dialog here. dono why.
        } else if theEvent.type == NSEventType.LeftMouseDown{
            self.mouseDown(theEvent)
        } else if theEvent.type == NSEventType.LeftMouseDragged {
            self.mouseDragged(theEvent)
        } else if theEvent.type == NSEventType.LeftMouseUp {
            self.mouseUp(theEvent)
        }
        super.sendEvent(theEvent)
    }
    override func mouseDown(theEvent: NSEvent) {
        self.initialLocation = theEvent.locationInWindow as NSPoint
    }
    
    override func mouseUp(theEvent: NSEvent) {
        // println("ReRender Window Shadow. 👌")
        self.invalidateShadow()
    }
    
    override func mouseDragged(theEvent: NSEvent) {
        var currentLocation:NSPoint
        var newOrigin:NSPoint = NSPoint(x: 0, y: 0)
        let screenFrame:NSRect = NSScreen.mainScreen()!.frame
        let windowFrame:NSRect = self.frame
        currentLocation = NSEvent.mouseLocation()
        newOrigin.x = currentLocation.x - self.initialLocation.x
        newOrigin.y = currentLocation.y - self.initialLocation.y
        if (newOrigin.y + windowFrame.size.height) > (screenFrame.origin.y + screenFrame.size.height){
            newOrigin.y = screenFrame.origin.y + (screenFrame.size.height - windowFrame.size.height)
        }
        self.setFrameOrigin(newOrigin)
    }
}