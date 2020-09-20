//
//  APIClient.swift
//  SpotiFav
//
//  Created by Cao Mai on 9/18/20.
//  Copyright © 2020 Cao. All rights reserved.
//

import Foundation

struct APIClient {
    static let shared = APIClient()
    let session = URLSession(configuration: .default)
    
    /// Exchanges an access code into an access token to use when making API calls
    ///
    /// This method takes the access code given back via the URI and exchanges it for an access token
    func exchangeCodeForAccessToken(code: String, completion: @escaping (AccessTokens)->Void) {
        do {
            
            let request = try Request.configureRequest(from: .token, withParams: .codeForToken(accessCode: code), and: .post, contains: nil)
//            print(request)
            print("xchange code fo token here")
            print(request.allHTTPHeaderFields)
            session.dataTask(with: request) { (data, response, error) in
            
                guard let safeData = data else {return}
                
                guard let accessTokens = try? JSONDecoder().decode(AccessTokens.self, from: safeData) else {return}
                
                completion(accessTokens)
              
            }.resume()
            
        } catch {}
    }
    
    /// Returns the user top tracks
    ///
    /// - Parameter token: takes in an access token
    /// - Returns: all of the user's top tracks
    
    func getUserTopTracks(token: String, completion: @escaping (MyTopTracks) -> Void) {
        
        checkForExpireToken(token: token) { (expiredToken) in
            
            if expiredToken.error.status == 401 {
                print("theres a token error")
                
                let refresh_token = UserDefaults.standard.string(forKey: "refresh_token")!
                print(refresh_token)
                self.exchangeRefreshTknToAccessTkn(refreshToken: refresh_token) { token in
                    print(token)
                    
                }
               
//                self.getUserTopTracks(token: newToken.accessToken) { (myTopTracks) in
//                    completion(myTopTracks)
//                }
                
            } else {
                
                do {
                    let request = try Request.configureRequest(from: .myTop(type: .tracks), accessToken: token, withParams: nil, and: .get, contains: nil)
                    print("request", request)
                    self.session.dataTask(with: request) { (data, response, error) in
                        
                        guard let safeData = data else {return}
                        
                        
                        guard let accessTokens = try? JSONDecoder().decode(MyTopTracks.self, from: safeData) else {return}
                        
                        completion(accessTokens)
                      
                    }.resume()
                } catch {
                    
                }
                
            }
            
        }
        
        
    }
    
    func checkForExpireToken(token: String, completion: @escaping (ExpireToken) -> Void) {
    ///routing to .userInfo as dummy
        do {
            let request = try Request.configureRequest(from: .userInfo, accessToken: token, withParams: nil, and: .get, contains: nil)
            print("request", request)
            session.dataTask(with: request) { (data, response, error) in
                
                guard let safeData = data else {return}
                
                guard let accessTokens = try? JSONDecoder().decode(ExpireToken.self, from: safeData) else {return}
                
                completion(accessTokens)
              
            }.resume()
        } catch {
            
        }
    }
    
    func exchangeRefreshTknToAccessTkn(refreshToken: String, completion: @escaping (AccessTokens)->Void) {
//        var accessToken: AccessTokens!
//        let sema = DispatchSemaphore(value: 0)
        do {
            let request = try Request.configureRequest(from: .token, withParams: .refreshTokenForAccessCode(refreshToken: refreshToken), and: .post, contains: nil)

            session.dataTask(with: request) { (data, response, error) in

                guard let safeData = data else {return}
//                print("data", data!)
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data!, options: [])
                    print(jsonObject)
                } catch {
                    print("error with data task")
                    print(error.localizedDescription)
                }
//
                
                guard let newToken = try? JSONDecoder().decode(AccessTokens.self, from: safeData) else {return}
                completion(newToken)
//                accessToken = newToken
//                sema.signal()
            }.resume()
        } catch {}
        
        
//        sema.wait()
//        return accessToken
    }
}
