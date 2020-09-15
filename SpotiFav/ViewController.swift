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
           spotifyAuthVC()


       }
    
    private func spotifyAuthVC() {
            let urlRequest = SpotifyNetworkLayer.requestAccessCode()
            print(urlRequest)
            let scheme = "auth"
            let session = ASWebAuthenticationSession(url: urlRequest, callbackURLScheme: scheme) { (callbackURL, error) in
                print(callbackURL)
                guard error == nil, let callbackURL = callbackURL else { return }
                let queryItems = URLComponents(string: callbackURL.absoluteString)?.queryItems
                guard let requestToken = queryItems?.first(where: { $0.name == "code" })?.value else { return }
    //            print(" Code \(requestToken)")
                print(requestToken)
                UserDefaults.standard.set(requestToken, forKey: "token")
                SpotifyNetworkLayer.exchangeCodeForToken(accessCode: requestToken) {results in
                    switch results {
                    case .success(let dictionary):
    //                    print(dictionary)
                        let token = (dictionary["access_token"]! as! String)
                        print("access-token", token)
                        
                        SpotifyNetworkLayer.fetchEndPoints(endPoint: .userInfo, bearerToken: token)
                        
                    case .failure(let error):
                        print(error)
                    }
                }
                
            }
            session.presentationContextProvider = self
            session.start()

        }

}

