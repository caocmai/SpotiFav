//
//  Network.swift
//  SpotiFav
//
//  Created by Cao Mai on 9/18/20.
//  Copyright © 2020 Cao. All rights reserved.
//

import UIKit

struct Request {
    
    static let spotifyAuthBase = "https://accounts.spotify.com/api/"
    static let spotifyAPICallBase = "https://api.spotify.com/v1/"
    
    enum Header {
        case GETHeader(accessTokeny: String)
        case POSTHeader
        
        func getProperHeader() -> [String:String] {
            switch self {
            case .GETHeader (let accessToken):
                return ["Accept": "application/json",
                        "Content-Type": "application/json",
                        "Authorization": "Bearer \(accessToken)"
                ]
            case .POSTHeader:
                let SPOTIFY_API_AUTH_KEY = "Basic \((SpotifyNetworkLayer.SPOTIFY_API_CLIENT_ID + ":" + SpotifyNetworkLayer.SPOTIFY_API_SCRET_KEY).data(using: .utf8)!.base64EncodedString())"
                return ["Authorization": SPOTIFY_API_AUTH_KEY,
                        "Content-Type": "application/x-www-form-urlencoded"]
            }
        }
    }
    
    enum EndPoints {
        
        case token
        case userInfo
        case artists(ids: [String])
        case artistTopTracks(artistId: String, country: Country)
        case search(q: String, type: SpotifyType)
        case playlists(id: String)
        case myTop(type: MyTopTypes)
        
        func getPath() -> String {
            switch self {
            case .token:
                return "token"
            case .userInfo:
                return "me"
            case .artists (let ids):
                return "artists&ids=\(ids.joined(separator: ","))"
            case .search(let q, let type):
                let convertSpacesToProperURL = q.replacingOccurrences(of: " ", with: "%20")
                return "search&q=\(convertSpacesToProperURL)&type\(type)"
            case .artistTopTracks(let id, let country):
                return "artists/\(id)/top-tracks&country\(country)"
            case .playlists (let id):
                return "playlists/\(id)"
            case .myTop(let type):
                return "me/top/\(type)"
            }
        }
        
        
    }
    
    public enum HTTPMethod: String{
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case patch = "PATCH"
        case delete = "DELETE"
    }
    
    
    static func configureRequest(from route: EndPoints, accessToken: String?=nil, withParams postParameters: PostParameters?, and method: HTTPMethod, contains body: Data?) throws -> URLRequest {
        
        var trueURL: URL!
        
        if accessToken != nil {
            guard let url = URL(string: Request.spotifyAPICallBase.appending(route.getPath())) else { fatalError("Error while unwrapping url")}
            trueURL = url
        } else {
            guard let url = URL(string: Request.spotifyAuthBase.appending(route.getPath())) else { fatalError("Error while unwrapping url")}
            trueURL = url
        }
        print(trueURL)
        var request = URLRequest(url: trueURL, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10.0)
        request.httpMethod = method.rawValue
        request.httpBody = body
        
        // checks to see if there's a token if so provide Header for GET method, if not get header for POST method
        if accessToken != nil {
            //            print("token in building", accessToken)
            //            print("parameters", postParameters?.getCodeForToken())
            //            print("header", Header.GETHeader(accessTokeny: accessToken!).getProperHeader())
            //            print(request)
            try configureParametersAndHeaders(parameters: postParameters?.getCodeForToken(), headers: Header.GETHeader(accessTokeny: accessToken!).getProperHeader(), request: &request)
        } else {
            // here the paramters can be nil because doesn't have accessToken yet
            try configureParametersAndHeaders(parameters: postParameters!.getCodeForToken(), headers: Header.POSTHeader.getProperHeader(), request: &request)
        }
        
        return request
    }
    
    //    static func configureOtherRequest(from route: EndPoints, with parameters: [String: Any]?, and method: HTTPMethod, contains body: Data?, accessToken: String?=nil) throws -> URLRequest {
    //        guard let url = URL(string: "https://api.spotify.com/v1/\(route.getPath())") else { fatalError("Error while unwrapping url")}
    //        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10.0)
    //        request.httpMethod = method.rawValue
    //        request.httpBody = body
    //        if accessToken != nil {
    //            try configureParametersAndHeaders(parameters: parameters, headers: Header.GETHeader.getProperHeader(accessToken: accessToken!), request: &request)
    //        } else {
    //            try configureParametersAndHeaders(parameters: parameters, headers: Header.POSTHeader.getProperHeader(accessToken: nil), request: &request)
    //        }
    //
    //        return request
    //    }
    
    static func configureParametersAndHeaders(parameters: [String: Any]?,
                                              headers: [String: String]?,
                                              request: inout URLRequest) throws {
        do {
            if let safeheaders = headers{
                try Encoder.setHeaders(for: &request, with: safeheaders)
            }
            if let safeParameters = parameters {
                try Encoder.encodeParameters(for: &request, with: safeParameters)
            }
        } catch {
            throw NetworkError.encodingFailed
        }
        
    }
    
    static func getAccessCodeURL() -> URL {
        let accessCodeBaseURL = "https://accounts.spotify.com/"
        
        let paramDictionary = ["client_id" : SpotifyNetworkLayer.SPOTIFY_API_CLIENT_ID,
                               "redirect_uri" : SpotifyNetworkLayer.REDIRECT_URI,
                               "response_type" : SpotifyNetworkLayer.RESPONSE_TYPE,
                               "scope" : SpotifyNetworkLayer.SCOPE.joined(separator: "%20")
        ]
        
        let mapToHTMLQuery = paramDictionary.map { key, value in
            
            return "\(key)=\(value)"
        }
        
        
        let stringQuery = mapToHTMLQuery.joined(separator: "&")
        
        let fullURL = URL(string: accessCodeBaseURL.appending("?\(stringQuery)"))
        
        return fullURL!
        
    }
}
//        request.httpBody = requestBodyComponents.query?.data(using: .utf8)

public struct Encoder {
    
    static func encodeParameters(for urlRequest: inout URLRequest, with parameters: [String: Any]) throws {
        guard let url = urlRequest.url else { throw NetworkError.missingURL }
        
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            urlComponents.queryItems = [URLQueryItem]()
            for (key,value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                urlComponents.queryItems?.append(queryItem)
            }
//            print("urel compentet", urlComponents)
            urlRequest.url = urlComponents.url

        }
    }
    
    static func setHeaders(for urlRequest: inout URLRequest, with headers: [String: String]) throws {
        for (key, value) in headers{
//            print(key)
//            print(value)
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
    }
}


enum SpotifyType {
    case album
    case artist
    case playlist
    case track
    case show
    case episode
    
    func getSpotifyType() -> String {
        switch self {
        case .album:
            return "album"
        case .artist:
            return "artist"
        case .playlist:
            return "playlist"
        case .track:
            return "track"
        case .show:
            return "show"
        case .episode:
            return "episode"
        }
    }
    
}

enum Country: String {
    case US = "US"
}


enum PostParameters {
    case codeForToken(accessCode: String)
    case refreshTokenForAccessCode(refreshToken: String)
    
    func getCodeForToken() -> [String:Any] {
        switch self {
        case .codeForToken(let code):
            return ["grant_type": "authorization_code",
                    "code": "\(code)",
                    "redirect_uri": K.REDIRECT_URI]
        case .refreshTokenForAccessCode(let refreshToken):
            return ["grant_type": "refresh_token",
                    "refresh_token": refreshToken
            ]
        }
    }
}

enum MyTopTypes {
    case tracks
    case artists
    
    func getType() -> String {
        switch self {
        case .tracks:
            return "tracks"
        case .artists:
            return "artists"
        }
    }
}

public enum NetworkError: String, Swift.Error {
    case parametersNil = "Parameters were nil"
    case encodingFailed = "Parameter Encoding failed"
    case decodingFailed = "Unable to Decode data"
    case missingURL = "The URL is nil"
    case couldNotParse = "Unable to parse the JSON response"
    case noData = "Data is nil"
    case fragmentResponse = "Response's body has fragments"
    case authenticationError = "You must be authenticated"
    case badRequest = "Bad request"
    case pageNotFound = "Page not found"
    case failed = "Request failed"
    case serverError = "Server error"
    case noResponse = "No response"
    case success = "Success"
    case tokenExpired = "Token expired"
}




class ViewController2: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        //        do {
        //            try Request.configureRequest(from: .artistTopTracks(artistId:"skjl", country: .US), with: .none, and: .get, contains: nil)
        //        } catch
        //        {}
    }
}
