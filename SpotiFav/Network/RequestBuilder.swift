//
//  RequestBuilder.swift
//  SpotiFav
//
//  Created by Cao Mai on 9/22/20.
//  Copyright © 2020 Cao. All rights reserved.
//

import Foundation


public protocol RequestBuilder {
    var method: HTTPMethodFinal { get }
    var headers: [String: String] { get }
    var baseURL: String { get }
    var path: String { get }
    var params: [String:Any]? { get }

    func toURLRequest() -> URLRequest
}

public extension RequestBuilder {
    
    func toURLRequest() -> URLRequest {
        
        let fullURL = URL(string: baseURL + path)
        print(fullURL)
        var request = URLRequest(url: fullURL!)

        if params != nil {
            
            if var components = URLComponents(url: fullURL!, resolvingAgainstBaseURL: false)  {
            components.queryItems = [URLQueryItem]()
            
            for (key, value) in params! {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems?.append(queryItem)
            }
            
            request.url = components.url
        }
    }
//        print(params)
//        components.queryItems = params
//        let url = components.url!
//        print("url with components", url)
        print(request)
        request.allHTTPHeaderFields = headers
        request.httpMethod = method.rawValue.uppercased()
        return request  
    }
}

struct BasicRequestBuilder: RequestBuilder {
    var method: HTTPMethodFinal
    var headers: [String: String] = [:]
    var baseURL: String
    var path: String
    var params: [String:Any]?
}



//
//public enum HTTPMethod: String {
//    case get
//    case post
//    case put
//    case delete
//}