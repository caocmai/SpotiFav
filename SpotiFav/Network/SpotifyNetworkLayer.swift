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
    //    static let accessTokenBaseURL = "https://accounts.spotify.com/api/token"
    static let baseAPICallURL = "https://api.spotify.com/v1/"
    static let SPOTIFY_API_CLIENT_ID = "619a17870dfc41da9bd10736497f8bd2"
    static let SPOTIFY_API_SCRET_KEY = "dd5e252ed5754c4889f733a82f5135e2"
    static let REDIRECT_URI = "spotifav://callback"
    static let SCOPE = ["user-read-email", "user-top-read"]
    static let RESPONSE_TYPE = "code"
    
    enum Result<T> {
        case success(T)
        case failure(Error)
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
    
    
    enum EndPoints {
        case authorize // Only used internally; DO NOT USE EXTERNALLY
        
        case userInfo
        case artists(ids: [String])
        case artistTopTracks(artistId: String, country: String="US")
        case search(q: String, type: SpotifyType)
        case playlists(id: String)
        case myTop(type: MyTopTypes)
        
        func getPath() -> String {
            switch self {
            case .authorize:
                return "authorize"
            case .userInfo:
                return "me"
            case .artists:
                return "artists"
            case .search:
                return "search"
            case .artistTopTracks(let id, _):
                return "artists/\(id)/top-tracks"
            case .playlists (let id):
                return "playlists/\(id)"
            case .myTop(let type):
                return "me/top/\(type)"
            }
        }
        
        func getHTTPRequestMethod() -> String {
            switch self {
            case .authorize:
                return "GET"
            case .userInfo:
                return "GET"
            default:
                return "GET"
            }
            
        }
        
        func getHeaders(accessToken: String) -> [String:String] {
            switch self {
//            case .authorize:
//                return ["Accept": "application/json",
//                        "Content-Type": "application/json",
//                        "Authorization": "Bearer \(accessToken)",
//                ]
            default:
                return [
                        "Accept": "application/json",
                        "Content-Type": "application/json",
                        "Authorization": "Bearer \(accessToken)",
                ]
            }
            
            
        }
        
        func getURLParams() -> [String:String] {
            
            switch self {
            case .authorize:
                return ["client_id" : SpotifyNetworkLayer.SPOTIFY_API_CLIENT_ID,
                        "redirect_uri" : SpotifyNetworkLayer.REDIRECT_URI,
                        "response_type" : SpotifyNetworkLayer.RESPONSE_TYPE,
                        "scope" : SpotifyNetworkLayer.SCOPE.joined(separator: "%20")
                ]
            case .artists (let ids):
                return ["ids": ids.joined(separator: ",")
                ]
            
            case .search(let q, let type):
                let convertSpacesToProperURL = q.replacingOccurrences(of: " ", with: "%20")
                return ["q" : convertSpacesToProperURL,
                        "type" : type.getSpotifyType()
                ]
            
            case .artistTopTracks( _, let country):
                return ["country" : country]
                
            default:
                return["NOT_VALID": "NOT_NEEDED"]
                
            }
            
        }
        
        func parasToString() -> String {
            let parameterArray = getURLParams().map{key, value in
                return "\(key)=\(value)"
            }
            return parameterArray.joined(separator: "&")
        }
        
    }
    
    static internal func fetchEndPoints(endPoint: EndPoints, bearerToken: String,  completion: @escaping (MyTopTracks?, String?, Playlist?) -> Void) {
        let path = endPoint.getPath()
        let params = endPoint.parasToString()
        let fullURL : URL!
        if params == "NOT_VALID=NOT_NEEDED" { // Means there's no additional query parameters necessary
            fullURL = URL(string: SpotifyNetworkLayer.baseAPICallURL.appending("\(path)"))
        } else {
            fullURL = URL(string: SpotifyNetworkLayer.baseAPICallURL.appending("\(path)?\(params)"))
        }
        
        print(fullURL!)
        var request = URLRequest(url: fullURL!)
//        print(endPoint.getHeaders(accessToken: bearerToken))
        request.allHTTPHeaderFields = endPoint.getHeaders(accessToken: bearerToken)
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
//                print(jsonObject)
//                completion(nil, nil, jsonObject)
                
            } catch {
                print(error.localizedDescription)
            }
            
            guard let safeData = data else {
                return completion(nil, "Do data", nil)
            }
//            guard let expireToken = try? JSONDecoder().decode(ExpireToken.self, from: safeData),
//            guard let userDetail = try? JSONDecoder().decode(UserModel.self, from: safeData)
//            guard let playlist = try? JSONDecoder().decode(Playlist.self, from: safeData)
            guard let playlist = try? JSONDecoder().decode(MyTopTracks.self, from: safeData)

                else {
                    return completion(nil, "Can't parse User Model", nil)
                }

            DispatchQueue.main.async {
                completion(playlist, nil, nil)
            }
            
        }.resume()
        
    }
    
    
    static internal func requestAccessCodeURL() -> URL {
        let path = EndPoints.authorize.getPath()
        // this might need to be changed becase change in code.
        let stringParams = EndPoints.authorize.parasToString() //hard coding it in
        let fullURL = URL(string: accessCodeBaseURL.appending("\(path)?\(stringParams)"))
        //        var request = URLRequest(url: fullURL!)
        //        request.httpMethod = EndPoints.authorize.getHTTPRequestMethod()
        return fullURL!
        
    }
    
    static internal func exchangeCodeForToken(accessCode: String, completion: @escaping(Result<[String:Any]>)->Void) {
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
