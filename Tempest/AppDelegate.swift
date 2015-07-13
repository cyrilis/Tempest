//
//  AppDelegate.swift
//  Tempest
//
//  Created by Cyril Hou on 15/4/18.
//  Copyright (c) 2015年 Cyrilis.com. All rights reserved.
//

import Cocoa
import Foundation

var mediaTap: SPMediaKeyTap!
var player : TPPlayer!

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func initPlayer() -> TPPlayer {
        return TPPlayer()
    }
    
    func startServer(){
        _ = TPServer()
    }

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        let thread = NSThread(target:self, selector: "startServer", object: nil)
        thread.start()
//        startServer()
        player = initPlayer();
        player.window.makeKeyAndOrderFront(self)

        mediaTap = SPMediaKeyTap(delegate: self)
        mediaTap.startWatchingMediaKeys()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
        if mediaTap != nil {
            mediaTap.stopWatchingMediaKeys()
        }
    }
    
    // Terminate Application When Player is closed.
    func applicationShouldTerminateAfterLastWindowClosed(theApplication: NSApplication) -> Bool{
        return true;
    }
    
    override func mediaKeyTap(keyTap: SPMediaKeyTap!, receivedMediaKeyEvent event: NSEvent!) {
        let keyCode = (event.data1 & 0xFFFF0000) >> 16
        let keyFlags = event.data1 & 0x0000FFFF
        let keyPressed = ((keyFlags & 0xFF00) >> 8) == 0xA
        _ = keyFlags & 0x1
        
        if keyPressed {
            switch keyCode {
            case Int(NX_KEYTYPE_PLAY):
                print("PLAY/PAUSE")
                player.run("$(\".controls .icon.play\").click()")
                return
            case Int(NX_KEYTYPE_FAST):
                print("NEXT")
                player.run("$(\".controls .icon.next\").click()")
                return
            case Int(NX_KEYTYPE_REWIND):
                print("PREV")
                player.run("$(\".controls .icon.heart\").click()")
                return
            default:
                return
            }
        }
    }

}

