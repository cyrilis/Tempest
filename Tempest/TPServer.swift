//
//  TPServer.swift
//  Tempest
//
//  Created by Cyril Hou on 15/7/13.
//  Copyright © 2015年 Cyrilis.com. All rights reserved.
//

import Foundation

class TPServer:NSObject {
    
    let server:HttpServer = HttpServer()
    let domain = "http://www.douban.com"
    let domain2 = "https://api.douban.com"

    override init () {
        super.init()

        self.route()
        
        self.server.start(9900)
    }
    
    func route(){
  
        self.server["/j/app/radio/people"] = {
            request, callback in
            let urlString:NSString = "\(self.domain)\(request.url)"
            self.HTTPGet(urlString as String){
                (data: String, error: String?) -> Void in
                if error != nil {
                    print(error)
                    callback(HttpResponse.OK(HttpResponseBody.HTML(error!)))
                } else {
                    callback(HttpResponse.Custom(HttpResponseBody.RAW(data), [("Access-Control-Allow-Origin","*"), ("Content-Type","application/json")], 200))
                }
            }
        }
        
        self.server["/j/app/radio/channels"] = { request, callback in
            print(request)
            let urlString:NSString = "\(self.domain)\(request.url)"
            self.HTTPGet(urlString as String){
                (data: String, error: String?) -> Void in
                if error != nil {
                    print(error)
                    callback(HttpResponse.OK(HttpResponseBody.HTML(error!)))
                } else {
                    callback(HttpResponse.Custom(HttpResponseBody.RAW(data), [("Access-Control-Allow-Origin","*"), ("Content-Type","application/json")], 200))
                }
            }
        }
        
        
        self.server["/v2/user/(.+)"] = { request, callback in
            print(request)
            let urlString:NSString = "\(self.domain2)\(request.url)"
            self.HTTPGet(urlString as String){
                (data: String, error: String?) -> Void in
                if error != nil {
                    print(error)
                    callback(HttpResponse.OK(HttpResponseBody.HTML(error!)))
                } else {
                    callback(HttpResponse.Custom(HttpResponseBody.RAW(data), [("Access-Control-Allow-Origin","*"), ("Content-Type","application/json")], 200))
                }
            }
        }
        
        self.server["/j/app/login"] = { request, callback in
            let urlString:NSString = "\(self.domain)\(request.url)"
            
            let queryString:NSString = request.body! as NSString
            self.HTTPPost(urlString as String, string: queryString as String){
                (data: String, error: String?) -> Void in
                if error != nil {
                    print(error)
                    callback(HttpResponse.OK(HttpResponseBody.HTML(error!)))
                } else {
                    callback(HttpResponse.Custom(HttpResponseBody.RAW(data), [("Access-Control-Allow-Origin","*"), ("Content-Type","application/json")], 200))
                }
            }
        }
        
        self.server["/"] = { request, callback in
            print(request)
            callback(.OK(.HTML("<h1>Hello World!</h1><br/>You asked for " + request.url)))
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
                    callback(NSString(data: data!, encoding: NSUTF8StringEncoding)! as String , nil)
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