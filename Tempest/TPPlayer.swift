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


//
//class TPPlayer: NSObject, WKScriptMessageHandler, WKNavigationDelegate{
//    var mainWindow : TPWindow
//
//    let webUrl = NSURL(fileURLWithPath: "\(NSBundle.mainBundle().resourcePath!)/DoubanFM/index.html")
//    
//    init(width:CGFloat, height:CGFloat){
//
//        var windowRect : NSRect = (NSScreen.mainScreen()!).frame
//        var frameRect : NSRect = NSMakeRect(
//            (NSWidth(windowRect) - width)/2,
//            (NSHeight(windowRect) - height)/2,
//            width, height)
//        var viewRect : NSRect = NSMakeRect(0, 0, width, height);
//        self.mainWindow = TPWindow(contentRect: frameRect, styleMask: NSBorderlessWindowMask  | NSClosableWindowMask | NSMiniaturizableWindowMask | NSTexturedBackgroundWindowMask, backing: NSBackingStoreType.Buffered, defer: false, screen: NSScreen.mainScreen())
//        
//        self.mainWindow.titleVisibility = NSWindowTitleVisibility.Hidden;
//        self.mainWindow.backgroundColor = NSColor.clearColor()
//        self.mainWindow.opaque = false
//        self.mainWindow.hasShadow = true
//        super.init()
//        self.loadWebView(viewReact: viewRect)
//    }
//
//    func loadWebView(viewReact viewRect: NSRect) {
//        var config = WKWebViewConfiguration()
//        var webPrefs = WKPreferences()
//        var contentController = WKUserContentController();
//        var userScript = WKUserScript(
//            source: "console.log('Hello form Naive.')",
//            injectionTime: WKUserScriptInjectionTime.AtDocumentEnd,
//            forMainFrameOnly: true
//        )
//        webPrefs.javaEnabled = false
//        webPrefs.plugInsEnabled = false
//        webPrefs.javaScriptEnabled = true
//        webPrefs.javaScriptCanOpenWindowsAutomatically = false
//
//        config.preferences = webPrefs
//        contentController.addUserScript(userScript)
//        contentController.addScriptMessageHandler(self, name: "callbackHandler");
//        contentController.addScriptMessageHandler(self, name: "closeApplication");
//        contentController.addScriptMessageHandler(self, name: "openLink")
//        contentController.addScriptMessageHandler(self, name: "toggleDrag")
//        config.userContentController = contentController;
//        
//        var webView:WKWebView = WKWebView(frame: viewRect, configuration: config)
//
//        webView.wantsLayer = true
//        webView.layer?.backgroundColor = NSColor.clearColor().CGColor
//        webView.layer?.cornerRadius = 5.0
//        webView.configuration.preferences.setValue(true, forKey: "developerExtrasEnabled")
//        webView.navigationDelegate = self
//        mainWindow.makeKeyAndOrderFront(self)
//        mainWindow.contentView = webView
//        var requestObj: NSURLRequest = NSURLRequest(URL: webUrl!)
//        webView.loadRequest(requestObj)
//    }
//    
//    func userContentController(userContentController: WKUserContentController,didReceiveScriptMessage message: WKScriptMessage){
//        println(message.name)
//        if(message.name == "closeApplication") {
//            mainWindow.close()
//        } else if(message.name == "openLink") {
//            if let checkURL = NSURL(string: message.body as! String) {
//                if NSWorkspace.sharedWorkspace().openURL(checkURL) {println("url successfully opened")}
//            } else {
//                println("invalid url")
//            }
//        } else if (message.name == "toggleDrag"){
//            if (message.body as! String == "true") {
//                mainWindow.cannotDrag = true;
//            }else{
//                mainWindow.cannotDrag = false;
//            }
//        }
//    }
//    
//    func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation) {
//    }
//    
//    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation, withError error: NSError) {
//        println("did fail")
//        println(error)
//    }
//    
//    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation, withError error: NSError) {
//        println("did fail provisional")
//        println(error)
//    }
//    
//    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
//        println("Finished Loading")
//        webView.evaluateJavaScript("console.log('Iniitialized from Nav')", completionHandler: {(data, error) in
//            println(error);
//            println(data);
//        })
//    }
//    
//    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation) {
//        println("did start")
//    }
//    
//    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: ((WKNavigationActionPolicy) -> Void)){
//        
//        if navigationAction.navigationType.rawValue == 0 {
//            println(navigationAction)
//            decisionHandler(.Cancel)
//            return;
//        }
//        decisionHandler(.Allow)
//    }
//    
//    func run(string:String) {
//        mainWindow.contentView.evaluateJavaScript(string as String , completionHandler: {(data, error) in
//            NSLog("running js %@: ---- %@", string, error)
//        })
//    }
//    
//}