//
//  TPProxy.swift
//  Tempest
//
//  Created by Cyril Hou on 15/5/30.
//  Copyright (c) 2015年 Cyrilis.com. All rights reserved.
//

import Foundation
import Taylor
class TPProxy:NSObject {

    let server = Taylor.Server()
    
    let domain = "http://www.douban.com"
    let domain2 = "https://api.douban.com"
    
    override init () {
        super.init()
        self.start()        
    }
    
    
    
    func start (port: NSInteger = 9900){
        
        
        
        server.addPostRequestHandler(Middleware.requestLogger(print))
        
        server.get("/") {
            request, response, callback in
            self.HTTPGet("http://www.cyrilis.com") {
                (data: String, error: String?) -> Void in
                if error != nil {
                    print(error)
                    response.bodyString = ""
                    callback(.Send(request, response))
                } else {
                    response.bodyString  = data
                    response.headers["Content-Type"] = "text/html"
                    callback(.Send(request, response))
                }
            }
        }
        
        server.get("/j/app/radio/people"){
            request, response, callback in
            var urlString:NSString = "\(self.domain)\(request.path)?"
            for (key, value) in request.arguments {
                urlString = "\(urlString)\(key)=\(value)&"
            }
            NSLog(urlString as String)
            self.HTTPGet(urlString as String){
                (data: String, error: String?) -> Void in
                if error != nil {
                    print(error)
                    response.bodyString = ""
                    callback(.Send(request, response))
                } else {
                    response.bodyString = data
                    response.headers["Content-Type"] = "application/json"
                    response.headers["Access-Control-Allow-Origin"] = "*"
                    callback(.Send(request, response))
                }
            }
        }
        
        
        server.get("/j/app/radio/channels"){
            request, response, callback in
            var urlString:NSString = "\(self.domain)\(request.path)?"
            for (key, value) in request.arguments {
                urlString = "\(urlString)\(key)=\(value)&"
            }
            NSLog(urlString as String)
            self.HTTPGet(urlString as String){
                (data: String, error: String?) -> Void in
                if error != nil {
                    print(error)
                    response.bodyString = ""
                    callback(.Send(request, response))
                } else {
                    response.bodyString = data
                    response.headers["Content-Type"] = "application/json"
                    response.headers["Access-Control-Allow-Origin"] = "*"
                    callback(.Send(request, response))
                }
            }
        }
        
        server.get("/v2/user/:id"){
            request, response, callback in
            var urlString:NSString = "\(self.domain2)\(request.path)?"
            for (key, value) in request.arguments {
                urlString = "\(urlString)\(key)=\(value)&"
            }
            NSLog(urlString as String)
            self.HTTPGet(urlString as String){
                (data: String, error: String?) -> Void in
                if error != nil {
                    print(error)
                    response.bodyString = ""
                    callback(.Send(request, response))
                } else {
                    response.bodyString = data
                    response.headers["Content-Type"] = "application/json"
                    response.headers["Access-Control-Allow-Origin"] = "*"
                    callback(.Send(request, response))
                }
            }
        }
        
        
        server.get("/j/app/login"){
            request, response, callback in
            let urlString:NSString = "\(self.domain)\(request.path)"
            NSLog(urlString as String)
            let email:String = request.arguments["email"]!
            let password:String = request.arguments["password"]!
            let app_name:String = "radio_desktop_win"
            let string = "version=100&app_name=\(app_name)&email=\(email)&password=\(password)" as NSString
            self.HTTPPost(urlString as String, string: string as String) {
                (data: String, error: String?) -> Void in
                if error != nil {
                    print(error)
                    response.bodyString = ""
                    callback(.Send(request, response))
                } else {
                    response.bodyString = data
                    response.headers["Content-Type"] = "application/json"
                    response.headers["Access-Control-Allow-Origin"] = "*"
                    callback(.Send(request, response))
                }
            }
        }
        
        server.startListening(port: port, forever: false) {
            result in
            switch result {
            case .Success:
                print("Up and running")
            case .Error(let e):
                print("Server start failed \(e)")
            }
        }
    }

    
    func HTTPsendRequest(request: NSMutableURLRequest,
        callback: (String, String?) -> Void) {
            let task = NSURLSession.sharedSession().dataTaskWithRequest(
                request,
                completionHandler: {
                    data, response, error in
                    if error != nil {
                        print(error)
                        callback("", error!.localizedDescription)
                    }
                    callback( NSString(data: data!, encoding: NSUTF8StringEncoding)! as String, nil)
            })

            task!.resume()
    }
    
    func HTTPGet(url: String, callback: (String, String?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        HTTPsendRequest(request, callback: callback)
    }
    
    func HTTPPost(url: String,
        string: String,
        callback: (String, String?) -> Void) {
            let request = NSMutableURLRequest(URL: NSURL(string: url)!)
            request.HTTPMethod = "POST"
            request.addValue("application/x-www-form-urlencoded",forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.HTTPBody = string.dataUsingEncoding(NSUTF8StringEncoding)
            HTTPsendRequest(request, callback: callback)
    }
    

}