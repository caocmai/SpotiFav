//
//  SpotifyNetworkLayer.swift
//  SpotiFav
//
//  Created by Cao Mai on 9/14/20.
//  Copyright © 2020 Cao. All rights reserved.
//

import Foundation


class SpotifyNetworkLayer {
    
    static let accessCodeBaseURL = "https://accounts.spotify.com/"
    static let accessTokenBaseURL = "https://accounts.spotify.com/api/token"
    static let baseAPICallURL = "https://api.spotify.com/v1/"
    static let SPOTIFY_API_CLIENT_ID = "619a17870dfc41da9bd10736497f8bd2"
    static let SPOTIFY_API_SCRET_KEY = "dd5e252ed5754c4889f733a82f5135e2"
    static let REDIRECT_URI = "spotifav://callback"
    static let scope = ["user-read-email", "user-top-read"]
    static let RESPONSE_TYPE = "code"
    
    enum Result<T> {
        case success(T)
        case failure(Error)
    }

    
//    /// Get token if have hte access Code
//    func requestAccessAndRefreshTokens(accessCode: String) {
//        let SPOTIFY_API_AUTH_KEY = "Basic \((SpotifyNetworkLayer.SPOTIFY_API_CLIENT_ID + ":" + SpotifyNetworkLayer.SPOTIFY_API_SCRET_KEY).data(using: .utf8)!.base64EncodedString())"
//        let requestHeaders: [String:String] = ["Authorization" : SPOTIFY_API_AUTH_KEY,
//                                               "Content-Type" : "application/x-www-form-urlencoded"]
//        var requestBodyComponents = URLComponents()
//        requestBodyComponents.queryItems = [URLQueryItem(name: "grant_type", value: "authorization_code"),
//                                            URLQueryItem(name: "code", value: accessCode),
//                                            URLQueryItem(name: "redirect_uri", value: SpotifyNetworkLayer.REDIRECT_URI)]
//        var request = URLRequest(url: URL(string: "https://accounts.spotify.com/api/token")!)
//        request.httpMethod = "POST"
//        request.allHTTPHeaderFields = requestHeaders
//        request.httpBody = requestBodyComponents.query?.data(using: .utf8)
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//            print("data", data)
//            print("response", response)
//        }.resume()
//    }
        
    
    enum EndPoints {
        case authorize
        //can add search case here, otherwise make a new endpoints
        case userInfo
        
        func getPath() -> String {
            switch self {
            case .authorize:
                return "authorize"
            case .userInfo:
                return "me"
            }
        }
        
        func getHTTPRequestMethod() -> String {
            switch self {
            case .authorize:
                return "GET"
            case .userInfo:
                return "GET"
            }
            
        }

        func getHeaders(accessToken: String) -> [String:String] {
            return ["Accept": "application/json",
                    "Content-Type": "application/json",
                    "Authorization": "Bearer \(accessToken)",
                    "Host": SpotifyNetworkLayer.baseAPICallURL
            ]
        }
        
        func getURLParams() -> [String:String] {
        
                return ["client_id" : SpotifyNetworkLayer.SPOTIFY_API_CLIENT_ID,
                        "redirect_uri" : SpotifyNetworkLayer.REDIRECT_URI,
                        "response_type" : SpotifyNetworkLayer.RESPONSE_TYPE,
                        "scope" : SpotifyNetworkLayer.scope.joined(separator: "%20")
                ]

        }
            
            
        
        func parasToString() -> String {
            let parameterArray = getURLParams().map{key, value in
                return "\(key)=\(value)"
            }
            return parameterArray.joined(separator: "&")
        }
        
    }
   
    static internal func fetchEndPoints(endPoint: EndPoints, bearerToken: String) {
        let path = endPoint.getPath()
        let fullURL = URL(string: SpotifyNetworkLayer.baseAPICallURL.appending("\(path)"))
        
        let SPOTIFY_API_AUTH_KEY = "Bearer \(bearerToken)"

        let requestHeaders: [String:String] = ["Authorization" : SPOTIFY_API_AUTH_KEY]
        
        var request = URLRequest(url: fullURL!)
        request.allHTTPHeaderFields = requestHeaders
//        request.addValue("Bearer " + bearerToken, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in

            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
                print(jsonObject)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
            
    }
    
    //NOT USING
     func fetchSpotifyProfile(accessToken: String) {
        let tokenURLFull = "https://api.spotify.com/v1/me"
    //    let topTrackURL = "https://api.spotify.com/v1/playlists/37i9dQZEVXbMDoHDwVN2tF"
    //    let myTopArtistURL = "https://api.spotify.com/v1/me/top/artists"
//        let tokenURLFull = "https://api.spotify.com/v1/me/top/tracks"
        let verify: NSURL = NSURL(string: tokenURLFull)!
        let request: NSMutableURLRequest = NSMutableURLRequest(url: verify as URL)
        request.addValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
            
            
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if error == nil {
                
                let result = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [AnyHashable: Any]
                print(result)
                //AccessToken
    //            print("Spotify Access Token: \(accessToken)")
    //            //Spotify Handle
    //            let spotifyId: String! = (result?["id"] as! String)
    //            print("Spotify Id: \(spotifyId ?? "")")
    //            //Spotify Display Name
    //            let spotifyDisplayName: String! = (result?["display_name"] as! String)
    //            print("Spotify Display Name: \(spotifyDisplayName ?? "")")
    //            //Spotify Email
    //            let spotifyEmail: String! = (result?["email"] as! String)
    //            print("Spotify Email: \(spotifyEmail ?? "")")
                
    //            let spotifyTopArtist: String! = (result?["name"] as! String)
    //            print("TOp artist", spotifyTopArtist ?? "")
                
                //Spotify Profile Avatar URL
    //            let spotifyAvatarURL: String!
    //            let spotifyProfilePicArray = result?["images"] as? [AnyObject]
    //            if (spotifyProfilePicArray?.count)! > 0 {
    //                spotifyAvatarURL = spotifyProfilePicArray![0]["url"] as? String
    //            } else {
    //                spotifyAvatarURL = "Not exists"
    //            }
    //            print("Spotify Profile Avatar URL: \(spotifyAvatarURL ?? "")")
            }
        }
        task.resume()
        }
    
    
    
    
    static internal func requestAccessCode() -> URL {
        let path = EndPoints.authorize.getPath()
        // this might need to be changed becase change in code.
        let stringParams = EndPoints.authorize.parasToString() //hard coding it in
        let fullURL = URL(string: accessCodeBaseURL.appending("\(path)?\(stringParams)"))
//        var request = URLRequest(url: fullURL!)
//        request.httpMethod = EndPoints.authorize.getHTTPRequestMethod()
        return fullURL!

    }
    
    static public func exchangeCodeForToken(accessCode: String, completion: @escaping(Result<[String:Any]>)->Void) {
//        let SPOTIFY_API_AUTH_KEY = "Basic \((SPOTIFY_API_CLIENT_ID + ":" + SPOTIFY_API_SCRET_KEY).data(using: .utf8)!.base64EncodedString())"
        
        let SPOTIFY_API_AUTH_KEY = "Basic \((SpotifyNetworkLayer.SPOTIFY_API_CLIENT_ID + ":" + SpotifyNetworkLayer.SPOTIFY_API_SCRET_KEY).data(using: .utf8)!.base64EncodedString())"

        
        let requestHeaders: [String:String] = ["Authorization" : SPOTIFY_API_AUTH_KEY,
                                               "Content-Type" : "application/x-www-form-urlencoded"]
        var requestBodyComponents = URLComponents()
        requestBodyComponents.queryItems = [URLQueryItem(name: "grant_type", value: "authorization_code"),
                                            URLQueryItem(name: "code", value: accessCode),
                                            URLQueryItem(name: "redirect_uri", value: SpotifyNetworkLayer.REDIRECT_URI)]
        
        var request = URLRequest(url: URL(string: "https://accounts.spotify.com/api/token")!)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = requestHeaders
        request.httpBody = requestBodyComponents.query?.data(using: .utf8)
        
//        var test : [String:Any] = ["":""]

        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
//            print(data)
//            print(response)
            
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
//                print(jsonObject)

//                let jsonDict = jsonObject as! [String:String]
                let test = ["access_token": jsonObject["access_token"], "expires_in": jsonObject["expires_in"]]
//                print(test)
                completion(.success(test as [String : Any]))
                
                
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
//
        
    }
    
    //NOT USING
    static internal func makeRequest(for endPoint: EndPoints, with accessToken: String?=nil) -> URL {
        let path = endPoint.getPath()
        let stringParams = endPoint.parasToString()
        let fullURL = URL(string: accessCodeBaseURL.appending("\(path)?\(stringParams)"))
        var request = URLRequest(url: fullURL!)
        request.httpMethod = endPoint.getHTTPRequestMethod()
        
        if let validAccessToken = accessToken {
            request.allHTTPHeaderFields = endPoint.getHeaders(accessToken: validAccessToken)
        }
        
        return fullURL!
    }
}
