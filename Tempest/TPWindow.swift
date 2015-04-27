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

    var initialLocation:NSPoint

    override var canBecomeKeyWindow :Bool {return true}
    override var canBecomeMainWindow :Bool {return true}
    
    override init(contentRect: NSRect, styleMask aStyle: Int, backing bufferingType: NSBackingStoreType, defer flag: Bool) {
        self.initialLocation = NSPoint(x: 0, y: 0)
        super.init(contentRect: contentRect, styleMask: aStyle, backing: bufferingType, defer: flag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sendEvent(theEvent: NSEvent) {
        if theEvent.type == NSEventType.LeftMouseDown{
            self.mouseDown(theEvent)
        } else if theEvent.type == NSEventType.LeftMouseDragged {
            self.mouseDragged(theEvent)
        }
        super.sendEvent(theEvent)
    }
    override func mouseDown(theEvent: NSEvent) {
        self.initialLocation = theEvent.locationInWindow as NSPoint
    }
    
    override func mouseDragged(theEvent: NSEvent) {
        var currentLocation:NSPoint
        var newOrigin:NSPoint = NSPoint(x: 0, y: 0)
        var screenFrame:NSRect = NSScreen.mainScreen()!.frame
        var windowFrame:NSRect = self.frame
        currentLocation = NSEvent.mouseLocation()
        newOrigin.x = currentLocation.x - self.initialLocation.x
        newOrigin.y = currentLocation.y - self.initialLocation.y
        if (newOrigin.y + windowFrame.size.height) > (screenFrame.origin.y + screenFrame.size.height){
            newOrigin.y = screenFrame.origin.y + (screenFrame.size.height - windowFrame.size.height)
        }
        self.setFrameOrigin(newOrigin)
    }
}