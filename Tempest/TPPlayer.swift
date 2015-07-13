//
//  TempestWebView.swift
//  Tempest
//
//  Created by Cyril Hou on 15/4/18.
//  Copyright (c) 2015年 Cyrilis.com. All rights reserved.
//

import Foundation
import WebKit

class TPPlayer: TPWebView {
//    override var width:CGFloat { get {return 350} set{} }
//    override var height:CGFloat { get {return 450} set {} }
    
    override func setupContentController (contentController:WKUserContentController) -> WKUserContentController{
        contentController.addScriptMessageHandler(self, name: "callbackHandler")
        contentController.addScriptMessageHandler(self, name: "closeApplication")
        contentController.addScriptMessageHandler(self, name: "openLink")
        contentController.addScriptMessageHandler(self, name: "toggleDrag")
        contentController.addScriptMessageHandler(self, name: "panelDo")
        contentController.addScriptMessageHandler(self, name: "togglePanel")
        return contentController
    }
    
    override func afterInit() {
        let panel = TPPanel()
        self.window.childWebView = panel
        panel.window.parentWebView = self
        self.window.addChildWindow(panel.window, ordered: NSWindowOrderingMode.Below)
        // close panel when TPPlayer main window is closed.
        NSNotificationCenter.defaultCenter().addObserver(panel.window, selector: "close", name: NSWindowWillCloseNotification, object: self.window)
        
    }
    override func resetFrame(frameRect: NSRect) -> NSRect {
        self.width = 350
        self.height = 450
        let windowRect: NSRect = (NSScreen.mainScreen()!).frame
        let newFrameRect:NSRect = NSMakeRect(
            windowRect.origin.x + (NSWidth(windowRect) - width)/2,
            windowRect.origin.y + (NSHeight(windowRect) - height)/2,
            self.width, self.height
        )
        return newFrameRect
    }
    
    override func userContentController(userContentController: WKUserContentController,didReceiveScriptMessage message: WKScriptMessage){
        print(message.name)
        if(message.name == "closeApplication") {
            self.window.close()
        } else if(message.name == "openLink") {
            if let checkURL = NSURL(string: message.body as! String) {
                if NSWorkspace.sharedWorkspace().openURL(checkURL) {print("url successfully opened")}
            } else {
                print("invalid url")
            }
        } else if (message.name == "toggleDrag"){
            if (message.body as! String == "true") {
                self.window.cannotDrag = true;
            }else{
                self.window.cannotDrag = false;
            }
        } else if (message.name == "panelDo") {
            if let panel = self.window.childWebView {
                panel.run(message.body as! String)
            }
        } else if (message.name == "togglePanel"){
            let playerRect = self.window.frame
            let panelRect = self.window.childWebView?.window.frame
            var frameRect:NSRect
            if panelRect!.origin.x > (playerRect.origin.x + 180) {
                frameRect = NSMakeRect(playerRect.origin.x + 140, playerRect.origin.y + 20, 210, 410)
            }else{
                frameRect = NSMakeRect(playerRect.origin.x + 340, playerRect.origin.y + 20, 210, 410)
            }
            self.window.childWebView?.window.setFrame(frameRect, display: true, animate: true)
        }
    }
    
}