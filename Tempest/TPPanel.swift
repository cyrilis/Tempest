//
//  TPPanel.swift
//  Tempest
//
//  Created by Cyril Hou on 15/5/31.
//  Copyright (c) 2015年 Cyrilis.com. All rights reserved.
//

import Foundation
import WebKit

class TPPanelWindow:TPWindow{
    override func mouseDragged(theEvent: NSEvent) {
    }
}

class TPPanel: TPWebView {
//    override var window: TPWindow
    override init(){
        let windowRect: NSRect = (NSScreen.mainScreen()!).frame
        let frameRect:NSRect = NSMakeRect(
            (NSWidth(windowRect) - 210)/2,
            (NSHeight(windowRect) - 410)/2,
            210, 410
        )
        super.init()
        let viewRect:NSRect = NSMakeRect(0,0,NSWidth(frameRect), NSHeight(frameRect));
        self.window = TPPanelWindow(contentRect: frameRect, styleMask: NSBorderlessWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask | NSTexturedBackgroundWindowMask, backing: NSBackingStoreType.Buffered, `defer`: false, screen: NSScreen.mainScreen())

        self.window.setFrame(self.resetFrame(frameRect), display: true)
        self.window.titleVisibility = NSWindowTitleVisibility.Hidden
        self.window.backgroundColor = NSColor.clearColor()
        self.window.opaque = false
        self.window.hasShadow = true
        self.loadWebView(viewRect)
        self.afterInit()
    }
    
    override func setupContentController (contentController:WKUserContentController) -> WKUserContentController{
        contentController.addScriptMessageHandler(self, name: "playerRun")
        return contentController
    }
    
    
    override func loadRequest (webView:WKWebView){
        let newWebUrl = NSURL(fileURLWithPath: "\(NSBundle.mainBundle().resourcePath!)/DoubanFM/panel.html")
        let requestObj:NSURLRequest = NSURLRequest(URL:newWebUrl)
        webView.loadRequest(requestObj)
    }
    
    override func resetFrame(frameRect: NSRect) -> NSRect {
        self.width = 210
        self.height = 410
        let windowRect: NSRect = (NSScreen.mainScreen()!).frame
        let newFrameRect:NSRect = NSMakeRect(
            windowRect.origin.x + (NSWidth(windowRect) - width)/2 + 270,
            windowRect.origin.y + (NSHeight(windowRect) - height)/2,
            self.width, self.height
        )
        
        return newFrameRect
    }
    
    override func userContentController(userContentController: WKUserContentController,didReceiveScriptMessage message: WKScriptMessage){
        print(message.name)
        if(message.name == "playerRun") {
            if let player = self.window.parentWebView {
                player.run(message.body as! String)
            }
        }
    }
}