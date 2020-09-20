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
    
    func xchangecodeforToken(code: String, completion: @escaping (AccessTokens)->Void) {
        do {
            
            let request = try Request.configureRequest(from: .accessToken, withParams: .codeForToken(accessCode: code), and: .post, contains: nil)
//            print(request)
            session.dataTask(with: request) { (data, response, error) in
            
                guard let safeData = data else {return}
                
                guard let accessTokens = try? JSONDecoder().decode(AccessTokens.self, from: safeData) else {return}
                
                completion(accessTokens)
              
            }.resume()
            
        } catch {}
    }
    
    func getUserTopTracks(token: String, completion: @escaping (MyTopTracks) -> Void) {
//        checkExpire(token: token) { (expiredToken) in
//            if expiredToken.error.status == 401 {
//
//            }
//        }
        do {
            let request = try Request.configureRequest(from: .myTop(type: .tracks), withParams: nil, and: .get, contains: nil, accessToken: token)
            print("request", request)
            session.dataTask(with: request) { (data, response, error) in
                
                guard let safeData = data else {return}
                
                guard let accessTokens = try? JSONDecoder().decode(MyTopTracks.self, from: safeData) else {return}
                
                completion(accessTokens)
              
            }.resume()
        } catch {
            
        }
    }
    
    func checkExpire(token: String, completion: @escaping (ExpireToken) -> Void) {
        do {
            let request = try Request.configureRequest(from: .myTop(type: .tracks), withParams: nil, and: .get, contains: nil, accessToken: token)
            print("request", request)
            session.dataTask(with: request) { (data, response, error) in
                
                guard let safeData = data else {return}
                
                guard let accessTokens = try? JSONDecoder().decode(ExpireToken.self, from: safeData) else {return}
                
                completion(accessTokens)
              
            }.resume()
        } catch {
            
        }
    }
}
