//
//  Top50ViewController.swift
//  SpotiFav
//
//  Created by Cao Mai on 9/16/20.
//  Copyright © 2020 Cao. All rights reserved.
//

import UIKit
import AVFoundation

class MyTopTracks: UIViewController {
    
//    var token : String? = nil
    
//    var refresh_token: String? = nil
    
    let client = APIClient(configuration: URLSessionConfiguration.default)
    
    let artistsTableView = UITableView()
    
    var albumns = [Alumn]()
    
    
    var player: AVAudioPlayer!
    var isPlaying = false
    var paused = false
    var trackPlaying = false
    var curretPlayingIndex = 0
    
    var simplifiedTracks = [SimpleTrack]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let token = (UserDefaults.standard.string(forKey: "token"))
        
        //        print(token)
//        let refreshToken = UserDefaults.standard.string(forKey: "refresh_token")
        
//        let global50 = "37i9dQZEVXbMDoHDwVN2tF"
        
//        print(token)
        
        if token == nil {
            emptyMessage(message: "Tap Auth Spotify", duration: 1.20)
        } else {
    
            client.call(request: .getUserTopTracks(token: token!, completions: { (result) in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let tracks):
                    //                print(tracks)
                    self.albumns = tracks.items
                    
                    for track in tracks.items {
                        let newTrack = SimpleTrack(artistName: track.artists.first?.name, id: track.id, title: track.name, previewURL: track.previewUrl, images: track.album!.images)
                        self.simplifiedTracks.append(newTrack)
                    }
                    
                    DispatchQueue.main.async {
                        //                            self.navigationItem.title = playlist.name
                        //                        self.tracks = playlist.tracks.items
                        self.configureTableView()
                    }
                }
            }))
        }
        configureNavBar()
    }
    
    private func configureNavBar() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "MY TOP TRACKS"
    }
    
    private func configureTableView() {
        self.view.addSubview(artistsTableView)
        artistsTableView.translatesAutoresizingMaskIntoConstraints = false
        artistsTableView.register(TableCell.self, forCellReuseIdentifier: String(describing: type(of: TableCell.self)))
        artistsTableView.dataSource = self
        artistsTableView.delegate = self
        artistsTableView.frame = self.view.bounds
    }
    
}


extension MyTopTracks: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return simplifiedTracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: type(of: TableCell.self))) as! TableCell

        let track = simplifiedTracks[indexPath.row]
        cell.setTrack(song: track, hideHeartButton: true)
        cell.simplifiedTrack = track
 
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    

}


