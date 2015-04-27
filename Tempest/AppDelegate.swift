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
        return TPPlayer(width: 350, height: 450)
    }

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        player = initPlayer();
        
        mediaTap = SPMediaKeyTap(delegate: self)
        mediaTap.startWatchingMediaKeys()
        
        // registerGlobalShortcut()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
        mediaTap.stopWatchingMediaKeys()
    }
    
    override func mediaKeyTap(keyTap: SPMediaKeyTap!, receivedMediaKeyEvent event: NSEvent!) {
        let keyCode = (event.data1 & 0xFFFF0000) >> 16
        let keyFlags = event.data1 & 0x0000FFFF
        let keyPressed = ((keyFlags & 0xFF00) >> 8) == 0xA
        let keyRepeat = keyFlags & 0x1
        
        if keyPressed {
            switch keyCode {
            case Int(NX_KEYTYPE_PLAY):
                println("PLAY/PAUSE")
                player.run("$(\".controls .icon.play\").click()")
                return
            case Int(NX_KEYTYPE_FAST):
                println("NEXT")
                player.run("$(\".controls .icon.next\").click()")
                return
            case Int(NX_KEYTYPE_REWIND):
                println("PREV")
                player.run("$(\".controls .icon.heart\").click()")
                return
            default:
                return
            }
        }
    }

}

