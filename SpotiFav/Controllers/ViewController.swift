//
//  ViewController.swift
//  SpotiFav
//
//  Created by Cao Mai on 9/14/20.
//  Copyright © 2020 Cao. All rights reserved.
//

import UIKit
import AuthenticationServices
import AVFoundation


class ViewController: UIViewController, ASWebAuthenticationPresentationContextProviding {
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return view.window ?? ASPresentationAnchor()
        
    }
    
    var token : String? = nil
    
    var player: AVAudioPlayer!
    var refresh_token: String? = nil
    
//    var testMP3Preview: URL?
    
    var timer:Timer!
    
    var isPlaying = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if token == nil {
            simpleButton()
        } else {
            print(token)
        }
        
//        print(Request.getAccessCodeURL())

        
        let tokenTest = (UserDefaults.standard.string(forKey: "token"))
        //        SpotifyNetworkLayer.fetchEndPoints(endPoint: .search(q: "Kenny G", type: .artist), bearerToken: tokenTest!)
        
//        print(tokenTest)
        
        let refreshToken = UserDefaults.standard.string(forKey: "refresh_token")
//        print(refreshToken)
        
        let global50 = "37i9dQZEVXbMDoHDwVN2tF"
        
        //        SpotifyNetworkLayer.fetchEndPoints(endPoint: .playlists(id: global50), bearerToken: tokenTest!) { (int, str, playlist) in
        //            print(int)
        //            print(str)
        //            print(playlist)
        //        }
        
        
//        SpotifyNetworkLayer.fetchEndPoints(endPoint: .myTop(type: .tracks), bearerToken: tokenTest!) { (int, str, playlist) in
//            print(int)
//                        print(str)
//                        print(playlist)
//            print("goes in here")
////            let casting = int as! MyTopTracks
////            let test = (casting.items.last?.previewURL)
////
////            self.downloadFileFromURL(url: test!)
//        }
        
        
        //        print(tokenTest)
        
//        call fetch -> data or expired token
//        check if reuturn is expired token
//            fetch refresh method
//            fetch the original api call with new token
        
        
        
//        let token = UserDefaults.standard.string(forKey: "token")!
        let token = "BQCN_0AsHDFqaTv1n6hognTkwuNoBLeexN6jJ0mjYLYdBPcQwDDErkJCRDGEZSQiuMHk0ET5mLiu89mVUwf6Qo_UwUKOwZbwHm3LXB1O7p9guFyANvG4w-b4tQ-jH0uM4auRAKGw-IJ6fRymUD04fMrq1QHucz-ovj22dnhiR_zTrChBAR--N9Y"
        APIClient.getUserTopTracks(token: token) { (tracks) in
            print(tracks)
//            let preivewURL = tracks.items.last?.previewURL
//            self.downloadFileFromURL(url: preivewURL!)

//        let refreshtoken = "AQAKczUFfZUTPCnmOGO6iosv8oVxNaklpsVii1X3M1tkYYJ0V0BJEXifR1wmCHwYuf-Z-j5eLrSJzs0AqRTja2WV81GB1nVf9h8xeqQt-Ht4WU2hyDKOBnpfeIa8prHDgBk"
//        let brannewtoken = APIClient.shared.exchangeRefreshTknToAccessTkn(refreshToken: refreshtoken)
//        print(brannewtoken)
        
        
        }
    }
    
    func downloadFileFromURL(url: URL){
        
        var downloadTask: URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url as URL, completionHandler: { [weak self](URL, response, error) -> Void in
            
            //            self!.testMP3Preview = URL!
            //            print(self?.testMP3Preview)
            self?.play(url: URL!)
        })
        
        downloadTask.resume()
        
    }
    
    func play(url: URL) {
        print("playing \(url)")
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            //            player.prepareToPlay()
            //            player.volume = 1.0
            //            player.play()
            //            let test = player.currentTime
            //            Thread.sleep(forTimeInterval: 20)
            //            player.pause()
            //            Thread.sleep(forTimeInterval: 2)
            //            player.play()
        } catch let error as NSError {
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
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
        
        if isPlaying {
            player.pause()
            isPlaying = false
        } else {
            player.play()
            isPlaying = true

            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        }
//
        
        
//                getSpotifyAccessCode()
        
    }
    
    
    @objc func updateTime() {
        let currentTime = Int(player.currentTime)
        let minutes = currentTime/60
        let seconds = currentTime - minutes * 60
        
        print(String(format: "%02d:%02d", minutes,seconds) as String)
    }
    
    private func getSpotifyAccessCode() {
        let urlRequest = SpotifyNetworkLayer.requestAccessCodeURL()
//        print(urlRequest)
        let scheme = "auth"
        let session = ASWebAuthenticationSession(url: urlRequest, callbackURLScheme: scheme) { (callbackURL, error) in
//            print(callbackURL)
            guard error == nil, let callbackURL = callbackURL else { return }
            let queryItems = URLComponents(string: callbackURL.absoluteString)?.queryItems
            guard let requestAccessCode = queryItems?.first(where: { $0.name == "code" })?.value else { return }
                        print(" Code \(requestAccessCode)")
//                            print(requestToken)
            UserDefaults.standard.set(requestAccessCode, forKey: "requestAccessCode")
//            SpotifyNetworkLayer.exchangeCodeForToken(accessCode: requestAccessCode) {results in
//                switch results {
//                case .success(let dictionary):
//                    //                    print(dictionary)
//                    let accessToken = (dictionary["access_token"]! as! String)
//                    let refresh_token = dictionary["refresh_token"]! as! String
//                    print("access-token", accessToken)
//                    print("refresh_token", refresh_token)
//                    UserDefaults.standard.set(accessToken, forKey: "token")
//                    UserDefaults.standard.set(refresh_token, forKey: "refresh_token")
//
//
////                    SpotifyNetworkLayer.fetchEndPoints(endPoint: .artists(ids: ["0oSGxfWSnnOXhD2fKuz2Gy","3dBVyJ7JuOMt4GE9607Qin"]), bearerToken: accessToken)
////                    SpotifyNetworkLayer.fetchEndPoints(endPoint: .search(q: "Kenny G", type: .artist), bearerToken: accessToken)
////                    SpotifyNetworkLayer.fetchEndPoints(endPoint: .artistTopTracks(artistId: "43ZHCT0cAZBISjO8DG9PnE"), bearerToken: accessToken)
////                    SpotifyNetworkLayer.fetchEndPoints(endPoint: .userInfo, bearerToken: accessToken)
////
//
//
//                case .failure(let error):
//                    print(error)
//                }
//            }
            
            
            
            
            
            //            let answer = (SpotifyNetworkLayer.exchangeCodeForToken(accessCode: requestAccessCode))
            //            if answer["expires_in"] as! Int == 3600 {
            //                print("will expire in about an hour!")
            //            }
            
            APIClient.exchangeCodeForAccessToken(code: requestAccessCode) { accesstoken in
                print(accesstoken)
                
                UserDefaults.standard.set(accesstoken.accessToken, forKey: "token")
                UserDefaults.standard.set(accesstoken.refreshToken, forKey: "refresh_token")
                
            }
            
            
            
        }
        session.presentationContextProvider = self
        session.start()
        
    }
    
}

