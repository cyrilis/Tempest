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

    override init(){
        var windowRect: NSRect = (NSScreen.mainScreen()!).frame
        var frameRect:NSRect = NSMakeRect(
            (NSWidth(windowRect) - self.width)/2,
            (NSHeight(windowRect) - self.height)/2,
            self.width, self.height
        )
        
        var viewRect:NSRect = NSMakeRect(0,0,NSWidth(frameRect), NSHeight(frameRect));
        self.window = TPWindow(contentRect: frameRect, styleMask: NSBorderlessWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask | NSTexturedBackgroundWindowMask, backing: NSBackingStoreType.Buffered, defer: false, screen: NSScreen.mainScreen())
        super.init()
        self.window.setFrame(self.resetFrame(frameRect), display: true)
        self.window.titleVisibility = NSWindowTitleVisibility.Hidden
        self.window.backgroundColor = NSColor.clearColor()
        self.window.opaque = false
        self.window.hasShadow = true
        self.loadWebView(viewRect)
        self.afterInit()
    }

    func afterInit(){}
    func resetFrame (frameRect:NSRect)->NSRect{ // for override custom position
        return frameRect
    }
    
    func loadWebView(viewRect: NSRect){
        var config = WKWebViewConfiguration()
        var webPrefs = WKPreferences()
        var contentController = WKUserContentController()
        var userScript = WKUserScript(
            source: "console.log(\"Hello From Nav\")", injectionTime: WKUserScriptInjectionTime.AtDocumentEnd, forMainFrameOnly: true)
        webPrefs.javaEnabled = false
        webPrefs.plugInsEnabled = false
        webPrefs.javaScriptEnabled = true
        webPrefs.javaScriptCanOpenWindowsAutomatically = false
        
        config.preferences = webPrefs
        contentController.addUserScript(userScript)
        contentController = self.setupContentController(contentController)
        config.userContentController = contentController
        
        var webView:WKWebView = WKWebView(frame: viewRect, configuration: config)
        webView.wantsLayer = true
        webView.layer?.backgroundColor = NSColor.clearColor().CGColor
        webView.layer?.cornerRadius = cornerRadius
        webView.configuration.preferences.setValue(true, forKey: "developerExtrasEnabled")
        webView.navigationDelegate = self
        window.makeKeyAndOrderFront(self)
        window.contentView = webView
        self.loadRequest(webView)
    }
    
    func loadRequest (webView:WKWebView){
        var requestObj:NSURLRequest = NSURLRequest(URL:webUrl!)
        webView.loadRequest(requestObj)
    }
    
    func setupContentController (contentController:WKUserContentController) -> WKUserContentController {
        contentController.addScriptMessageHandler(self, name: "doSomeThing")
        return contentController
    }
    
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        println(message.name)
        if(message.name == "doSomeThing"){
            // Do Some Thing.
        }
    }
    
    func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation){
    }
    
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        println("Failed load webView WebContent")
        println(error)
    }
    
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        println("Did Fail Provisional Navigation")
        println(error)
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        println("webView Loaded!!!")
        webView.evaluateJavaScript("console.log(\"WebKit Loaded And Called From Swift!\")", completionHandler: { (data, error) in
            if error != nil {
                println(error)
            }
            if data != nil{
                println(data)
            }
            
        })
    }
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        println("Start load WebKit Navigation")
    }
    
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType.rawValue == 0 {
            println("stop Navigation")
            decisionHandler(.Cancel)
            return
        }
        decisionHandler(.Allow)
    }
    func run(string:String){
        window.contentView.evaluateJavaScript(string as String, completionHandler: {
            (data, error) in
            NSLog("runing js in Naive: %@ -----", string)
        })
    }
}