//
//  ViewController.swift
//  SpotiFav
//
//  Created by Cao Mai on 9/14/20.
//  Copyright © 2020 Cao. All rights reserved.
//

import UIKit
import AuthenticationServices


class ViewController: UIViewController, ASWebAuthenticationPresentationContextProviding {
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return view.window ?? ASPresentationAnchor()
        
    }
    
    var token : String? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if token == nil {
            simpleButton()
        } else {
            print(token)
        }
        
        let tokenTest = (UserDefaults.standard.string(forKey: "token"))
//        SpotifyNetworkLayer.fetchEndPoints(endPoint: .search(q: "Kenny G", type: .artist), bearerToken: tokenTest!)
        
        print(tokenTest)
        
        let global50 = "37i9dQZEVXbMDoHDwVN2tF"
        
//        SpotifyNetworkLayer.fetchEndPoints(endPoint: .playlists(id: global50), bearerToken: tokenTest!) { (int, str, playlist) in
//            print(int)
//            print(str)
//            print(playlist)
//        }
        
        
        SpotifyNetworkLayer.fetchEndPoints(endPoint: .myTop(type: .tracks), bearerToken: tokenTest!) { (int, str, playlist) in
            print(int)
            print(str)
            print(playlist)
        }
        
        
//        print(tokenTest)
    }
    
    
    func simpleButton() {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.setTitle("Log In", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    @objc func buttonTapped() {
        print("button tapped")
        getSpotifyAccessCode()
        
    }
    
    private func getSpotifyAccessCode() {
        let urlRequest = SpotifyNetworkLayer.requestAccessCodeURL()
        print(urlRequest)
        let scheme = "auth"
        let session = ASWebAuthenticationSession(url: urlRequest, callbackURLScheme: scheme) { (callbackURL, error) in
            print(callbackURL)
            guard error == nil, let callbackURL = callbackURL else { return }
            let queryItems = URLComponents(string: callbackURL.absoluteString)?.queryItems
            guard let requestAccessCode = queryItems?.first(where: { $0.name == "code" })?.value else { return }
            //            print(" Code \(requestToken)")
            //                print(requestToken)
            UserDefaults.standard.set(requestAccessCode, forKey: "requestAccessCode")
            SpotifyNetworkLayer.exchangeCodeForToken(accessCode: requestAccessCode) {results in
                switch results {
                case .success(let dictionary):
                    //                    print(dictionary)
                    let accessToken = (dictionary["access_token"]! as! String)
                    print("access-token", accessToken)
                    UserDefaults.standard.set(accessToken, forKey: "token")

                    
//                    SpotifyNetworkLayer.fetchEndPoints(endPoint: .artists(ids: ["0oSGxfWSnnOXhD2fKuz2Gy","3dBVyJ7JuOMt4GE9607Qin"]), bearerToken: accessToken)
//                    SpotifyNetworkLayer.fetchEndPoints(endPoint: .search(q: "Kenny G", type: .artist), bearerToken: accessToken)
//                    SpotifyNetworkLayer.fetchEndPoints(endPoint: .artistTopTracks(artistId: "43ZHCT0cAZBISjO8DG9PnE"), bearerToken: accessToken)
//                    SpotifyNetworkLayer.fetchEndPoints(endPoint: .userInfo, bearerToken: accessToken)
//
                    
                    
                case .failure(let error):
                    print(error)
                }
            }
            
        }
        session.presentationContextProvider = self
        session.start()
        
    }
    
}

