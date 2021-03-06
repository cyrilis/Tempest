//
//  TPWebView.swift
//  Tempest
//
//  Created by Cyril Hou on 15/5/31.
//  Copyright (c) 2015年 Cyrilis.com. All rights reserved.
//

import Foundation
import WebKit
import Cocoa

class TPWebView: NSObject, WKScriptMessageHandler, WKNavigationDelegate{
    var window: TPWindow
    var webUrl = NSURL(fileURLWithPath: "\(NSBundle.mainBundle().resourcePath!)/DoubanFM/index.html")
    var width:CGFloat = 200
    var height:CGFloat = 400
    var cornerRadius:CGFloat = 5.0
    var isReady = false
    var scriptList = [String]()
    
    override init(){
        let windowRect: NSRect = (NSScreen.mainScreen()!).frame
        let frameRect:NSRect = NSMakeRect(
            (NSWidth(windowRect) - self.width)/2,
            (NSHeight(windowRect) - self.height)/2,
            self.width, self.height
        )
        
        let viewRect:NSRect = NSMakeRect(0,0,NSWidth(frameRect), NSHeight(frameRect));
        self.window = TPWindow(contentRect: frameRect, styleMask: (NSBorderlessWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask | NSTexturedBackgroundWindowMask), backing: NSBackingStoreType.Buffered, `defer`: false, screen: NSScreen.mainScreen())
        super.init()
        self.window.setFrame(self.resetFrame(frameRect), display: true)
        self.window.titleVisibility = NSWindowTitleVisibility.Hidden
        self.window.backgroundColor = NSColor.clearColor()
        self.window.opaque = false
        self.window.hasShadow = true
        self.loadWebView(viewRect)
        self.window.invalidateShadow()
        self.afterInit()
    }

    func afterInit(){}
    func resetFrame (frameRect:NSRect)->NSRect{ // for override custom position
        return frameRect
    }
    
    func loadWebView(viewRect: NSRect){
        let config = WKWebViewConfiguration()
        let webPrefs = WKPreferences()
        var contentController = WKUserContentController()
        let userScript = WKUserScript(
            source: "console.log(\"Hello From Nav\")", injectionTime: WKUserScriptInjectionTime.AtDocumentEnd, forMainFrameOnly: true)
        webPrefs.javaEnabled = false
        webPrefs.plugInsEnabled = false
        webPrefs.javaScriptEnabled = true
        webPrefs.javaScriptCanOpenWindowsAutomatically = false
        
        config.preferences = webPrefs
        contentController.addUserScript(userScript)
        contentController = self.setupContentController(contentController)
        config.userContentController = contentController
        
        let webView:WKWebView = WKWebView(frame: viewRect, configuration: config)
        webView.wantsLayer = true
        webView.layer?.backgroundColor = NSColor.clearColor().CGColor
        webView.layer?.cornerRadius = cornerRadius
        webView.configuration.preferences.setValue(true, forKey: "developerExtrasEnabled")
        webView.navigationDelegate = self
        webView
        window.makeKeyAndOrderFront(self)
        window.contentView.addSubview(webView)
        webView.frame = window.contentView.frame
        self.loadRequest(webView)
    }
    
    func loadRequest (webView:WKWebView){
        let requestObj:NSURLRequest = NSURLRequest(URL:webUrl)
        webView.loadRequest(requestObj)
    }
    
    func setupContentController (contentController:WKUserContentController) -> WKUserContentController {
        contentController.addScriptMessageHandler(self, name: "doSomeThing")
        return contentController
    }
    
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        print(message.name)
        if(message.name == "doSomeThing"){
            // Do Some Thing.
        }
    }
    
    func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation){
    }
    
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        print("Failed load webView WebContent")
        print(error)
        NSLog("\(error)")
    }
    
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        print("Did Fail Provisional Navigation")
        print(error)
        NSLog("\(error)")
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        print("webView Loaded!!!")
        window.invalidateShadow()
        self.isReady = true
        for string in self.scriptList {
            webView.evaluateJavaScript(string as String, completionHandler: nil )
        }
        webView.evaluateJavaScript("console.log(\"WebKit Loaded And Called From Swift!\")", completionHandler: nil)
    }
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Start load WebKit Navigation")
    }
    
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType.rawValue == 0 {
            print("stop Navigation")
            decisionHandler(.Cancel)
            return
        }
        decisionHandler(.Allow)
    }
    func run(string:String){
//        let webView = window.contentView as! WKWebView
        let webView = window.contentView.subviews.first as! WKWebView
        if self.isReady {
            webView.evaluateJavaScript(string as String, completionHandler: nil)
        }else {
            print("Save for excuse later.")
            self.scriptList.append(string)
        }
    }
}