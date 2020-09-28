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
import Kingfisher


class ViewController: UIViewController, ASWebAuthenticationPresentationContextProviding {
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return view.window ?? ASPresentationAnchor()
        
    }
    
    var token : String? = nil
    
    var player: AVAudioPlayer!
    var refresh_token: String? = nil
    
    //    var testMP3Preview: URL?
    
    var timer: Timer!
    
    var isPlaying = false
    
    let client = APIClient(configuration: URLSessionConfiguration.default)
    
    let artistsTableView = UITableView()
    
    var artists = [ArtistItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let token = (UserDefaults.standard.string(forKey: "token"))
        let refreshToken = UserDefaults.standard.string(forKey: "refresh_token")
        let global50 = "37i9dQZEVXbMDoHDwVN2tF"
        
       print(token)
        
        if token == nil {
            emptyMessage(message: "Tap Auth Spotify To Authenticate!", duration: 1.20)
        } else {

        client.call(request: .getUserTopArtists(token: refreshToken!, completions: { (result) in
                    switch result {
                    case .failure(let error):
                        print(error)
                        print("got back completion; error")
                    case .success(let results):
                        self.artists = results.items
                        DispatchQueue.main.async {
                            self.configureTableView()
//                            print(self.artists)
                        }
                    }
                }))
            
        }
        configureNavBar()

    }
    
    private func configureNavBar() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "MY TOP"
        let authSpotifyBarButton = UIBarButtonItem(title: "Auth Spotify", style: .plain, target: self, action: #selector(authButtontapped))
        self.navigationItem.rightBarButtonItem = authSpotifyBarButton
    }
    
    @objc func authButtontapped() {
        getSpotifyAccessCode()
    }
    
    private func configureTableView() {
        artistsTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(artistsTableView)
        artistsTableView.register(TableCell.self, forCellReuseIdentifier: String(describing: type(of: TableCell.self)))
        artistsTableView.dataSource = self
        artistsTableView.delegate = self
        artistsTableView.frame = self.view.bounds
    }
    
    func downloadFileFromURL(url: URL){
        
        var downloadTask: URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: { [weak self] (URL, response, error) in

            self?.play(url: URL!)
        })
        
        downloadTask.resume()
        
    }
    
    func play(url: URL) {
        print("playing \(url)")
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            //                        player.prepareToPlay()
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
        
        //        if isPlaying {
        //            player.pause()
        //            isPlaying = false
        //        } else {
        //            player.play()
        //            isPlaying = true
        //
        //            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        //        }
        //

    }
    
    
    @objc func updateTime() {
        let currentTime = Int(player.currentTime)
        let minutes = currentTime/60
        let seconds = currentTime - minutes * 60
        
        print(String(format: "%02d:%02d", minutes,seconds) as String)
    }
    
    private func getSpotifyAccessCode() {
        let urlRequest = client.getSpotifyAccessCodeURL()
        print(urlRequest)
        let scheme = "auth"
        let session = ASWebAuthenticationSession(url: urlRequest, callbackURLScheme: scheme) { (callbackURL, error) in
            guard error == nil, let callbackURL = callbackURL else { return }
            let queryItems = URLComponents(string: callbackURL.absoluteString)?.queryItems
            guard let requestAccessCode = queryItems?.first(where: { $0.name == "code" })?.value else { return }
            print(" Code \(requestAccessCode)")
            //                            print(requestToken)
            UserDefaults.standard.set(requestAccessCode, forKey: "requestAccessCode")
            
            // exchanges access code to access token with refresh token
            self.client.call(request: .accessCodeToAccessToken(code: requestAccessCode, completion: { (token) in
                print(token)
                switch token {
                case .failure(let error):
                    print(error)
                case .success(let token):
                    UserDefaults.standard.set(token.accessToken, forKey: "token")
                    UserDefaults.standard.set(token.refreshToken, forKey: "refresh_token")
                }
            }))
        }
        session.presentationContextProvider = self
        session.start()
    }
    
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: type(of: TableCell.self))) as! TableCell
        
        let artist = artists[indexPath.row]

        for image in artist.images {
            if image.height == 160 {
                cell.imageView?.kf.setImage(with: image.url, options: []) { result in
                    switch result {
                    case .success(let value):
                        DispatchQueue.main.async {
                            cell.textLabel?.text = self.artists[indexPath.row].name
                            cell.imageView?.image = value.image
                        }

                    case .failure(let error):
                        print("error")
                    }

                }

            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let artist = artists[indexPath.row]
        
        let destinationVC = ArtistTopTracksVC()
        destinationVC.artist = artist
        artistsTableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
}
