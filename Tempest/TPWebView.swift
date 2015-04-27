//
//  TPWebView.swift
//  Tempest
//
//  Created by Cyril Hou on 15/4/23.
//  Copyright (c) 2015年 Cyrilis.com. All rights reserved.
//

import Foundation
import Cocoa
import WebKit

class TPWebView: WKWebView {
    override var mouseDownCanMoveWindow :Bool {
        return true
    }
}