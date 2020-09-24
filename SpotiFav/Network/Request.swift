//
//  Request.swift
//  SpotiFav
//
//  Created by Cao Mai on 9/22/20.
//  Copyright © 2020 Cao. All rights reserved.
//

import Foundation

public enum HTTPMethodFinal: String {
    case get, post, put, delete
}

struct RequestFinal {
    let builder: RequestBuilder
    let completion: (Result<Data, Error>) -> Void
    
    private static func buildRequest(method: HTTPMethodFinal, header: [String:String], baseURL: URL, path: String, params: [String:Any]?=nil, completion: @escaping (Result<Data, Error>) -> Void) -> RequestFinal {
        
        let builder = BasicRequestBuilder(method: method, headers: header, baseURL: baseURL, path: path, params: params)
        
        return RequestFinal(builder: builder, completion: completion)
    }
}


extension RequestFinal {
    
    static func refreshTokenToAccessToken(completion: @escaping (Result<Tokens, Error>) -> Void) -> RequestFinal? {
        // making the call
        
//        let refreshtoken = "AQAKczUFfZUTPCnmOGO6iosv8oVxNaklpsVii1X3M1tkYYJ0V0BJEXifR1wmCHwYuf-Z-j5eLrSJzs0AqRTja2WV81GB1nVf9h8xeqQt-Ht4WU2hyDKOBnpfeIa8prHDgBk"
//
//        let paramas = ["grant_type": "refresh_token",
//                       "refresh_token": refreshtoken
//        ]
//
//        let SPOTIFY_API_AUTH_KEY = "Basic \((K.SPOTIFY_API_CLIENT_ID + ":" + K.SPOTIFY_API_SCRET_KEY).data(using: .utf8)!.base64EncodedString())"
//
//        let header = ["Authorization": SPOTIFY_API_AUTH_KEY,
//                      "Content-Type": "application/x-www-form-urlencoded"]
//
//        let spotifyAuthBase = URL(string: "https://accounts.spotify.com/api/")!
//
//        let path = "token"
//
        guard let refreshToken = UserDefaults.standard.string(forKey: "refresh_token") else {return nil}
        return RequestFinal.buildRequest(method: .post, header: Header.POSTHeader.getProperHeader(), baseURL: SpotifyBaseURL.authBaseURL.url, path: EndingPath.token.getPath(), params: PostParameters.getCodeForToken(.refreshTokenForAccessCode(refreshToken: refreshToken))()
            
        ) { result in // the data is passed on to here!
            // makeing decoding call
            print("data result", result)
            result.decoding(Tokens.self, completion: completion)
        }
        
    }
    
    
    static func checkExpiredToken(token: String, completion: @escaping (Result<ExpireToken, Error>) -> Void) -> RequestFinal {
        RequestFinal.buildRequest(method: .get, header: Header.GETHeader(accessTokeny: token).getProperHeader(), baseURL: SpotifyBaseURL.APICallBase.url, path: EndingPath.userInfo.getPath()) { (result) in
            
            result.decoding(ExpireToken.self, completion: completion)
        }
    }
    
    static func getUserTopTracks(token: String, completions: @escaping (Result<MyTopTracks, Error>) -> Void) -> RequestFinal {
        
//        RequestFinal.buildRequest(method: .get, header: Header.GETHeader(accessTokeny: token).getProperHeader(), baseURL: SpotifyBaseURL.APICallBase.url, path: EndingPath.myTop(type: .tracks).getPath()) { (result) in
//
//            result.decoding(MyTopTracks.self, completion: completions)
//        }
        
        let apiclient = Client(configuration: URLSessionConfiguration.default)
        
        print("token passed to here", token)
        return checkExpiredToken(token: token) { expireToken in
            switch expireToken {
            case .failure(_):
                print("failed to find expired token, token still valid")
                print(token)
                RequestFinal.buildRequest(method: .get, header: Header.GETHeader(accessTokeny: token).getProperHeader(), baseURL: SpotifyBaseURL.APICallBase.url, path: EndingPath.myTop(type: .tracks).getPath()) { (result) in
                    print("tracks found")
                           
                           result.decoding(MyTopTracks.self, completion: completions)
                       }
            case .success:
                print("got back expired token, token expired")
                
                apiclient.call(request: refreshTokenToAccessToken(completion: { (token) in
                    switch token {
                    case .success(let token):
                        print(token)
                        
                        apiclient.call(request: .getUserTopTracks(token: token.accessToken, completions: completions))
                    case .failure(let error):
                        print(error)
                    }
                    
                })!)
                
//                apiclient.sendrefreshTokenToAccessToken { (newToken) in
//                    switch newToken {
//                    case .success(let token):
//                        print("new token", token)
//                        RequestFinal.buildRequest(method: .get, header: Header.GETHeader(accessTokeny: token.accessToken).getProperHeader(), baseURL: SpotifyBaseURL.APICallBase.url, path: EndingPath.myTop(type: .tracks).getPath()) { (result) in
//
//                            result.decoding(MyTopTracks.self, completion: completions)
//                        }
//                    case .failure:
//                        print("error")
//                    }
//                }
            }
        }
        
       
    }
    
    static func accessCodeToAccessToken(code: String, completion: @escaping (Result<Tokens, Error>) -> Void) -> RequestFinal {
        
        RequestFinal.buildRequest(method: .post, header: Header.POSTHeader.getProperHeader(), baseURL: SpotifyBaseURL.authBaseURL.url, path: EndingPath.token.getPath(), params: PostParameters.codeForToken(accessCode: code).getCodeForToken()) { (result) in
            
            result.decoding(Tokens.self, completion: completion)
        }
    }
    
    static func getUserInfo(token: String, completion: @escaping (Result<UserModel, Error>) -> Void) -> RequestFinal {
        RequestFinal.buildRequest(method: .get, header: Header.GETHeader(accessTokeny: token).getProperHeader(), baseURL: SpotifyBaseURL.APICallBase.url, path: EndingPath.userInfo.getPath()) { (user) in
            user.decoding(UserModel.self, completion: completion)
        }
    }
    
}



public extension Result where Success == Data, Failure == Error {
    
    // make a decoding function with generic input
    func decoding<M: Model>(_ model: M.Type, completion: @escaping (Result<M, Error>) -> Void) {
        
        DispatchQueue.global().async {
            // decodes the data using flatMap
            let result = self.flatMap { data -> Result<M, Error> in
                do {
                    let decoder = M.decoder
                    let model = try decoder.decode(M.self, from: data)
                    return .success(model)
                } catch {
                    return .failure(error)
                }
            }
            DispatchQueue.main.async {
                // pass parsed data to completion
                completion(result)
            }
        }
    }
}
